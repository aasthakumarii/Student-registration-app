variable "name" {
 default = "/ecs/student_logs"
}

variable "endpoint" {
 default = "aasthakumari.0105@gmail.com"
}

variable "alarm_name" {
 default = "ecs-cpu-high"
}

variable "metric_name" {
 default = "CPUUtilization"
}

variable "namespace" {
 default = "AWS/ECS"
}

variable "period" {
 default = 300
 type = number
}

variable "statistic" {
 default = "Average"
}

variable "threshold" {
 default = 50
 type = number
}

variable "cluster_name" {
 default = "student_logs"
}

variable "service_name" {
 default = "student_logs-service"
}  