variable "ami" {
  description = "AMI for the Database instance"
  type        = string
}

variable "private_subnet" {
  description = "Private subnet ID"
  type        = string
}

variable "security_group" {
  description = "Security group ID"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
  default     = null
}

variable "user_data" {
  description = "Cloud-init/bootstrap script for database instance"
  type        = string
  default     = null
}
