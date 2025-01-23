provider "aws" {
  region  = var.REGION
  profile = var.PROFILE
}
terraform {
   backend "s3" {}
}

module "main" {
  source = "./../../"

  PROJECT_NAME      = var.PROJECT_NAME
  ENV               = var.ENV
  INSTANCE_PORT     = var.INSTANCE_PORT
  ALB_PORT          = var.ALB_PORT
  APP_INSTANCE_TYPE = var.APP_INSTANCE_TYPE

}

output "instance_sg_id" { value = module.main.instance_sg_id }
output "alb_sg_id"      { value = module.main.alb_sg_id }
