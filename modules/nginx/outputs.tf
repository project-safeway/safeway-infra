output "public_ip" {
  value = aws_eip.nginx.public_ip
}

output "elastic_ip" {
  value = aws_eip.nginx.public_ip
}