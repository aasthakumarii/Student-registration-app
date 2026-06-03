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

variable "ssh_cidr" {
  type = string

  default = "0.0.0.0/0"
}

variable "instance_type" {
  type = string

  default = "t2.micro"
}

variable "key_name" {
  type = string

  default = "student-key"
}

variable "backend_repo_name" {
  type = string

  default = "student-backend"
}

variable "frontend_repo_name" {
  type = string

  default = "student-frontend"
}
