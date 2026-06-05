output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "service_name" {
  value = aws_ecs_service.demo_service.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.demoapp.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs_logs.name
}