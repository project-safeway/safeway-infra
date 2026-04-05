output "nginx_elastic_ip" {
  description = "Elastic IP of the NGINX reverse proxy"
  value       = module.nginx.elastic_ip
}

output "database_private_ip" {
  description = "Private IP of the database EC2 instance"
  value       = module.database.private_ip
}

output "frontend_private_ips" {
  description = "Private IPs of frontend EC2 instances"
  value       = module.frontend.private_ips
}

output "backend_private_ips" {
  description = "Private IPs of backend EC2 instances"
  value       = module.backend.private_ips
}

output "ecr_frontend_repository_url" {
  description = "ECR repository URL for frontend image"
  value       = module.ecr.frontend_repository_url
}

output "ecr_core_repository_url" {
  description = "ECR repository URL for core API image"
  value       = module.ecr.core_repository_url
}

output "ecr_financial_repository_url" {
  description = "ECR repository URL for financial API image"
  value       = module.ecr.financial_repository_url
}

output "ssh_key_pair_name" {
  description = "EC2 key pair name used for SSH access"
  value       = aws_key_pair.ec2_ssh.key_name
}

output "ssh_private_key_path" {
  description = "Local path to generated SSH private key"
  value       = local_sensitive_file.ec2_ssh_private_key.filename
}
