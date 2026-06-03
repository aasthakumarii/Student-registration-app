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

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "backend_ecr_url" {
  value = module.ecr.backend_repo_url
}

output "frontend_ecr_url" {
  value = module.ecr.frontend_repo_url
}

