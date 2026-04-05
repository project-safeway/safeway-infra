variable "frontend_repository_name" {
  description = "ECR repository name for frontend image"
  type        = string
}

variable "core_repository_name" {
  description = "ECR repository name for core API image"
  type        = string
}

variable "financial_repository_name" {
  description = "ECR repository name for financial API image"
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting for ECR repositories"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Enable ECR vulnerability scan on push"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Allow repository deletion even if images exist"
  type        = bool
  default     = false
}
