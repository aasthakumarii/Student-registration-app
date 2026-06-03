resource "aws_ecr_repository" "backend" {

  name = var.backend_repo_name

  force_delete = true

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "frontend" {

  name = var.frontend_repo_name

  force_delete = true

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

