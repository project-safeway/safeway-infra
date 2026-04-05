output "frontend_repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "core_repository_url" {
  value = aws_ecr_repository.core.repository_url
}

output "financial_repository_url" {
  value = aws_ecr_repository.financial.repository_url
}
