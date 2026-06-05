variable "cluster_name" {
  default = "student-cluster"
}

variable "task_family" {
  default = "student-app-task"
}

variable "cpu" {
  default = 2048
}

variable "memory" {
  default = 4096
}

variable "mysql_image" {
  default = "mysql:8.0"
}

variable "root_pass" {
  default = "rootpass123"
}

variable "mysql_db" {
  default = "student_registration"
}

variable "mysql_user" {
  default = "root"
}

variable "mysql_pass" {
  default = "rootpass123"
}

variable "backend_image" {
  type = string
}

variable "db_host" {
  default = "127.0.0.1"
  description = "Use 127.0.0.1 for ECS Fargate awsvpc mode - all containers share localhost"
}

variable "db_user" {
  default = "root"
}

variable "db_pass" {
  default = "rootpass123"
}

variable "db_name" {
  default = "student_registration"
}

variable "frontend_image" {
  type = string
}

variable "service_name" {
  default = "student-service"
}

variable "desired_count" {
  default = 1
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}