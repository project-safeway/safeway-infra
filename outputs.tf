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

output "redis_private_ip" {
  description = "Private IP of the Redis EC2 instance"
  value       = module.redis.private_ip
}

output "github_actions_oidc_role_arn" {
  description = "IAM role ARN to be assumed by GitHub Actions (OIDC); null if enable_github_actions_oidc is false"
  value       = var.enable_github_actions_oidc ? aws_iam_role.github_actions[0].arn : null
}
