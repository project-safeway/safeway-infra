resource "aws_instance" "frontend" {
  ami           = var.ami
  instance_type = "t3.micro"

  subnet_id = var.private_subnet

  vpc_security_group_ids = [
    var.security_group
  ]

  tags = {
    Name = "safeway-frontend"
  }
}
