module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}


module "ecr" {
  source = "./modules/ecr"

  backend_repo_name  = var.backend_repo_name
  frontend_repo_name = var.frontend_repo_name
}

module "ecs" {

  source = "./modules/ecs"

  subnet_ids = [
    module.vpc.public_subnet_id
  ]

  security_group_id = module.vpc.security_group_id

  backend_image = "${module.ecr.backend_repo_url}:latest"

  frontend_image = "${module.ecr.frontend_repo_url}:latest"
}
