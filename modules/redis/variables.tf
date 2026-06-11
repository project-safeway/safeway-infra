variable "ami" {
  description = "AMI for the Redis instance"
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
