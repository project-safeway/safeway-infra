output "public_subnet_a" {
  value = aws_subnet.public_a.id
}

output "private_subnet_frontend" {
  value = aws_subnet.private_frontend.id
}

output "private_subnet_backend" {
  value = aws_subnet.private_backend.id
}

output "private_subnet_database" {
  value = aws_subnet.private_database.id
}
