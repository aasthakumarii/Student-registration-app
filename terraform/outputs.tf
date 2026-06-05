output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.public_subnet_id
}

output "security_group_id" {
  value = module.vpc.security_group_id
}

output "instance_profile_name" {
  value = module.iam.instance_profile_name
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "backend_ecr_url" {
  value = module.ecr.backend_repo_url
}

output "frontend_ecr_url" {
  value = module.ecr.frontend_repo_url
}

