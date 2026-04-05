resource "tls_private_key" "ec2_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_ssh" {
  key_name   = var.ssh_key_pair_name
  public_key = tls_private_key.ec2_ssh.public_key_openssh
}

resource "local_sensitive_file" "ec2_ssh_private_key" {
  filename        = "${path.module}/${var.ssh_private_key_filename}"
  content         = tls_private_key.ec2_ssh.private_key_pem
  file_permission = "0600"
}
