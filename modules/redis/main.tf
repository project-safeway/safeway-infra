resource "aws_instance" "redis" {
  ami           = var.ami
  instance_type = "t3.micro"

  subnet_id = var.private_subnet

  vpc_security_group_ids = [
    var.security_group
  ]

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    export DEBIAN_FRONTEND=noninteractive
    cat > /etc/apt/apt.conf.d/99force-ipv4 <<'EOT'
    Acquire::ForceIPv4 "true";
    EOT

    wait_for_apt_lock() {
      while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 \
        || fuser /var/lib/dpkg/lock >/dev/null 2>&1 \
        || fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
        sleep 3
      done
    }

    retry_cmd() {
      local retries="$1"
      shift
      local n=1
      until "$@"; do
        if [ "$n" -ge "$retries" ]; then
          return 1
        fi
        n=$((n + 1))
        sleep 5
      done
    }

    wait_for_apt_lock
    retry_cmd 8 apt-get -o Acquire::Retries=5 update -y
    wait_for_apt_lock
    retry_cmd 8 apt-get install -y curl ca-certificates

    retry_cmd 6 sh -c "curl -fsSL https://get.docker.com | sh"
    systemctl enable docker
    systemctl restart docker

    retry_cmd 8 /usr/bin/docker pull redis:7-alpine
    /usr/bin/docker rm -f safeway-redis || true
    /usr/bin/docker run -d \
      --name safeway-redis \
      --restart unless-stopped \
      -p 6379:6379 \
      -v redis_data:/data \
      redis:7-alpine \
      redis-server --save 60 1 --loglevel warning --bind 0.0.0.0 --protected-mode no --bind 0.0.0.0 --protected-mode no

    echo "=== redis docker ps ==="
    /usr/bin/docker ps || true
    echo "=== redis last logs ==="
    /usr/bin/docker logs --tail 120 safeway-redis || true
  EOF

  tags = {
    Name = "safeway-redis"
  }
}
