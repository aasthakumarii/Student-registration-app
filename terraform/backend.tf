terraform {
  backend "s3" {
    bucket = "backend-terraform-student-registration-app"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}