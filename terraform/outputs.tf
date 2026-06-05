output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.public_subnet_id
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "backend_ecr_url" {
  value = module.ecr.backend_repo_url
}

output "frontend_ecr_url" {
  value = module.ecr.frontend_repo_url
}

output "log_group_name" {
  value = module.ecs.log_group_name
}

output "instructions" {
  value = <<-EOT
  
  ========================================
  DEPLOYMENT SUCCESSFUL
  ========================================
  
  Cluster: ${module.ecs.cluster_name}
  Service: ${module.ecs.service_name}
  
  To get the public IP of your running task:
  
  aws ecs list-tasks --cluster ${module.ecs.cluster_name} --service ${module.ecs.service_name} --region ${var.aws_region}
  
  Then describe the task to get ENI and public IP:
  
  aws ecs describe-tasks --cluster ${module.ecs.cluster_name} --tasks <TASK_ARN> --region ${var.aws_region}
  
  View logs:
  
  aws logs tail ${module.ecs.log_group_name} --follow --region ${var.aws_region}
  
  ========================================
  EOT
}

