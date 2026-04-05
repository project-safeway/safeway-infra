output "private_ips" {
  value = aws_instance.frontend[*].private_ip
}
