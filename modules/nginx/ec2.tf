resource "aws_instance" "nginx" {
  ami           = var.ami
  instance_type = "t3.micro"

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.security_group
  ]

  user_data                   = var.user_data
  user_data_replace_on_change = true
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name

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