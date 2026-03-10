resource "aws_instance" "nginx" {
  ami           = var.ami
  instance_type = "t3.micro"

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.security_group
  ]

  associate_public_ip_address = true

  tags = {
    Name = "safeway-nginx"
  }
}

resource "aws_eip" "nginx" {
  instance = aws_instance.nginx.id
  domain   = "vpc"

  tags = {
    Name = "safeway-nginx-eip"
  }
}