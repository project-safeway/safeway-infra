variable "ami" {
  description = "AMI for the NGINX instance"
  type        = string
}

variable "subnet_id" {
  type = string
}

variable "security_group" {
  type = string
}

variable "user_data" {
  description = "Cloud-init/bootstrap script for nginx instance"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM instance profile name attached to nginx instance"
  type        = string
  default     = null
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
  default     = null
}