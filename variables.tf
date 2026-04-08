variable "server_name" {
  description = "Public DNS name used by NGINX"
  type        = string
  default     = "app.seudominio.com"
}

variable "ssh_key_pair_name" {
  description = "EC2 key pair name used for SSH access"
  type        = string
  default     = "safeway-ec2-key"
}

variable "ssh_private_key_filename" {
  description = "Local filename to store the generated SSH private key"
  type        = string
  default     = "safeway-ec2-key.pem"
}

variable "create_ec2_ecr_iam_resources" {
  description = "Create IAM role/profile for EC2 to pull from private ECR. Disable in restricted labs."
  type        = bool
  default     = false
}

variable "existing_ec2_instance_profile_name" {
  description = "Existing IAM instance profile name to attach to EC2 (e.g. LabInstanceProfile)."
  type        = string
  default     = null
}

variable "frontend_ecr_repository_name" {
  description = "ECR repository name for frontend image"
  type        = string
  default     = "safeway-frontend"
}

variable "core_ecr_repository_name" {
  description = "ECR repository name for core API image"
  type        = string
  default     = "safeway-core"
}

variable "financial_ecr_repository_name" {
  description = "ECR repository name for financial API image"
  type        = string
  default     = "safeway-financial"
}

variable "ecr_image_tag_mutability" {
  description = "Image tag mutability setting for ECR repositories"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_scan_on_push" {
  description = "Enable ECR vulnerability scan on push"
  type        = bool
  default     = true
}

variable "ecr_force_delete" {
  description = "Allow ECR repository deletion even when images exist"
  type        = bool
  default     = false
}

variable "frontend_image" {
  description = "Container image for frontend"
  type        = string
  default     = "ghcr.io/your-org/safeway-frontend:latest"
}

variable "core_api_image" {
  description = "Container image for core API"
  type        = string
  default     = "ghcr.io/your-org/safeway-core:latest"
}

variable "financial_api_image" {
  description = "Container image for financial API"
  type        = string
  default     = "ghcr.io/your-org/safeway-financial:latest"
}

variable "core_db_user" {
  description = "Core API database user"
  type        = string
  default     = "safeway"
}

variable "core_db_password" {
  description = "Core API database password"
  type        = string
  sensitive   = true
}

variable "core_db_name" {
  description = "Core API database name"
  type        = string
  default     = "safeway_core"
}

variable "financial_db_user" {
  description = "Financial API database user"
  type        = string
  default     = "safeway"
}

variable "financial_db_password" {
  description = "Financial API database password"
  type        = string
  sensitive   = true
}

variable "financial_db_name" {
  description = "Financial API database name"
  type        = string
  default     = "safeway_financial"
}

variable "rabbitmq_user" {
  description = "RabbitMQ username"
  type        = string
  default     = "safeway"
}

variable "rabbitmq_password" {
  description = "RabbitMQ password"
  type        = string
  sensitive   = true
}

variable "rabbitmq_vhost" {
  description = "RabbitMQ virtual host"
  type        = string
  default     = "/"
}

variable "auth_service_client_id" {
  description = "Client ID used by core service authentication"
  type        = string
  default     = "safeway-core"
}

variable "auth_service_client_secret" {
  description = "Client secret used by core service authentication"
  type        = string
  sensitive   = true
}

variable "google_project_id" {
  description = "Google project ID used by core API"
  type        = string
  default     = ""
}

variable "google_maps_api_key" {
  description = "Google maps API key used by core API"
  type        = string
  sensitive   = true
  default     = ""
}

variable "google_application_credentials" {
  description = "Path to Google credentials JSON inside backend host"
  type        = string
  default     = "/run/secrets/gcp-credentials.json"
}

variable "google_service_account_json_base64" {
  description = "Base64-encoded Google service account JSON written to backend host at runtime"
  type        = string
  sensitive   = true
  default     = ""
}
