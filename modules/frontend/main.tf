resource "aws_instance" "frontend" {
  count         = length(var.private_subnets)
  ami           = var.ami
  instance_type = "t3.micro"

  subnet_id = var.private_subnets[count.index]

  vpc_security_group_ids = [
    var.security_group
  ]

  user_data                   = var.user_data
  user_data_replace_on_change = true
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name

  tags = {
    Name = "${var.instance_name_prefix}-${count.index + 1}"
  }
}
