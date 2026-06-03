data "aws_ami" "ubuntu" {
  most_recent = true

  owners = [
    "099720109477"
  ]

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  filter {
    name = "virtualization-type"

    values = [
      "hvm"
    ]
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  ssh_cidr           = var.ssh_cidr
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"

  backend_repo_name  = var.backend_repo_name
  frontend_repo_name = var.frontend_repo_name
}

module "ec2" {
  source = "./modules/ec2"

  ami_id                = data.aws_ami.ubuntu.id
  instance_type         = var.instance_type
  subnet_id             = module.vpc.public_subnet_id
  security_group_id     = module.vpc.security_group_id
  instance_profile_name = module.iam.instance_profile_name
  key_name              = var.key_name
}
