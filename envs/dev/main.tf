provider "aws" {
  region  = var.REGION
  profile = var.PROFILE
}

module "dev" {
  source = "./../../"

  port         = var.PORT
  project_name = var.PROJECT_NAME
  ENV          = var.ENV
}