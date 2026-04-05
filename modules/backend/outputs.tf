output "private_ips" {
  value = aws_instance.backend[*].private_ip
}
