output "public_subnet_a" {
  value = aws_subnet.public_a.id
}

output "public_subnet_b" {
  value = aws_subnet.public_b.id
}

output "private_subnet_frontend" {
  value = aws_subnet.private_frontend.id
}

output "private_subnet_frontend_a" {
  value = aws_subnet.private_frontend.id
}

output "private_subnet_frontend_b" {
  value = aws_subnet.private_frontend_b.id
}

output "private_subnets_frontend" {
  value = [aws_subnet.private_frontend.id, aws_subnet.private_frontend_b.id]
}

output "private_subnet_backend" {
  value = aws_subnet.private_backend.id
}

output "private_subnet_backend_a" {
  value = aws_subnet.private_backend.id
}

output "private_subnet_backend_b" {
  value = aws_subnet.private_backend_b.id
}

output "private_subnets_backend" {
  value = [aws_subnet.private_backend.id, aws_subnet.private_backend_b.id]
}

output "private_subnet_database" {
  value = aws_subnet.private_database.id
}

output "private_subnet_database_a" {
  value = aws_subnet.private_database.id
}

output "private_subnet_database_b" {
  value = aws_subnet.private_database_b.id
}
