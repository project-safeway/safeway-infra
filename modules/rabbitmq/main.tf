resource "aws_instance" "rabbitmq" {
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

    retry_cmd 8 /usr/bin/docker pull rabbitmq:3.13-management
    /usr/bin/docker rm -f safeway-rabbitmq || true
    /usr/bin/docker run -d \
      --name safeway-rabbitmq \
      --restart unless-stopped \
      -p 5672:5672 \
      -p 15672:15672 \
      -e RABBITMQ_DEFAULT_USER=${var.rabbitmq_user} \
      -e RABBITMQ_DEFAULT_PASS=${var.rabbitmq_password} \
      rabbitmq:3.13-management

    echo "=== rabbitmq docker ps ==="
    /usr/bin/docker ps || true
    echo "=== rabbitmq last logs ==="
    /usr/bin/docker logs --tail 120 safeway-rabbitmq || true
  EOF

  tags = {
    Name = "safeway-rabbitmq"
  }
}