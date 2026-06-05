variable "aws_region" {
  type = string

  default = "ap-south-1"
}

variable "availability_zone" {
  type = string

  default = "ap-south-1a"
}

variable "vpc_cidr" {
  type = string

  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type = string

  default = "10.0.1.0/24"
}

variable "backend_repo_name" {
  type = string

  default = "student-backend"
}

variable "frontend_repo_name" {
  type = string

  default = "student-frontend"
}
