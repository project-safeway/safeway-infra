resource "aws_instance" "database" {
  ami           = var.ami
  instance_type = "t3.micro"

  subnet_id = var.private_subnet

  vpc_security_group_ids = [
    var.security_group
  ]

  user_data                   = var.user_data
  user_data_replace_on_change = true
  key_name = var.key_name

  tags = {
    Name = "safeway-database"
  }
}
