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