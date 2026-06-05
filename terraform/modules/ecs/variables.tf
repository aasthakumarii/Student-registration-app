variable "cluster_name" {
  default = "3T-ECS"
}

variable "task_family" {
  default = "3T-ECS-Task"
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
  default = "rootpass"
}

variable "mysql_db" {
  default = "student_registration"
}

variable "mysql_user" {
  default = "appuser"
}

variable "mysql_pass" {
  default = "password123"
}

variable "backend_image" {
  default = "160900807677.dkr.ecr.us-east-1.amazonaws.com/backend-app:latest"
}

variable "db_host" {
  default = "localhost"
}

variable "db_user" {
  default = "appuser"
}

variable "db_pass" {
  default = "password123"
}

variable "db_name" {
  default = "student_registration"
}

variable "frontend_image" {
  default = "160900807677.dkr.ecr.us-east-1.amazonaws.com/frontend-app:latest"
}

variable "service_name" {
  default = "3T-ECS-Service"
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