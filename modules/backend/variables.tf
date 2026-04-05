variable "ami" {
  description = "AMI for the Backend instance"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs where backend instances will be created"
  type        = list(string)
}

variable "security_group" {
  description = "Security group ID"
  type        = string
}

variable "instance_name_prefix" {
  description = "Prefix used to tag backend instances"
  type        = string
  default     = "safeway-backend"
}

variable "user_data" {
  description = "Cloud-init/bootstrap script for backend instances"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM instance profile name attached to backend instances"
  type        = string
  default     = null
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
  default     = null
}
