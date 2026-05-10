resource "tls_private_key" "ec2_ssh" {
  count = var.create_ec2_ssh_key_material ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_ssh" {
  count = var.create_ec2_ssh_key_material ? 1 : 0

  key_name   = var.ssh_key_pair_name
  public_key = tls_private_key.ec2_ssh[0].public_key_openssh
}

resource "local_sensitive_file" "ec2_ssh_private_key" {
  count = var.create_ec2_ssh_key_material ? 1 : 0

  filename        = "${path.module}/${var.ssh_private_key_filename}"
  content         = tls_private_key.ec2_ssh[0].private_key_pem
  file_permission = "0600"
}
