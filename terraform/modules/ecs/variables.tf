variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "backend_image" {
  type = string
}

variable "frontend_image" {
  type = string
}

variable "aws_region" {
  type = string
}
