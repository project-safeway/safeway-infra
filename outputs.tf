output "nginx_elastic_ip" {
  description = "Elastic IP of the NGINX reverse proxy"
  value       = module.nginx.elastic_ip
}

output "database_private_ip" {
  description = "Private IP of the database EC2 instance"
  value       = module.database.private_ip
}

output "rabbitmq_private_ip" {
  description = "Private IP of the RabbitMQ EC2 instance"
  value       = module.rabbitmq.private_ip
}
