provider "aws" {
  region  = var.REGION
  profile = var.PROFILE
}
terraform {
   backend "s3" {}
}

module "main" {
  source = "./../../"

  INSTANCE_PORT = var.INSTANCE_PORT
  ALB_PORT      = var.ALB_PORT
  PROJECT_NAME  = var.PROJECT_NAME
  ENV           = var.ENV

}

output "instance_sg_id" { value = module.main.instance_sg_id }
output "alb_sg_id"      { value = module.main.alb_sg_id }
