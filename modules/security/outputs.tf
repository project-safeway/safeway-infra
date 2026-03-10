output "nginx_sg" {
  value = aws_security_group.nginx_sg.id
}

output "frontend_sg" {
  value = aws_security_group.frontend_sg.id
}

output "backend_sg" {
  value = aws_security_group.backend_sg.id
}

output "db_sg" {
  value = aws_security_group.db_sg.id
}
