variable "ami" {
  description = "AMI for the RabbitMQ instance"
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

variable "rabbitmq_user" {
  description = "RabbitMQ username"
  type        = string
}

variable "rabbitmq_password" {
  description = "RabbitMQ password"
  type        = string
}
