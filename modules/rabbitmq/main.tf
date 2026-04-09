resource "aws_instance" "rabbitmq" {
  ami           = var.ami
  instance_type = "t3.micro"

  subnet_id = var.private_subnet

  vpc_security_group_ids = [
    var.security_group
  ]

  user_data = <<-EOF
    #!/bin/bash
    set -e

    apt-get update -y
    apt-get install -y docker.io

    systemctl enable docker
    systemctl start docker

    docker rm -f safeway-rabbitmq || true
    docker pull rabbitmq:3.13-management
    docker run -d \
      --name safeway-rabbitmq \
      --restart unless-stopped \
      -p 5672:5672 \
      -p 15672:15672 \
      -e RABBITMQ_DEFAULT_USER=guest \
      -e RABBITMQ_DEFAULT_PASS=guest \
      rabbitmq:3.13-management
  EOF

  tags = {
    Name = "safeway-rabbitmq"
  }
}