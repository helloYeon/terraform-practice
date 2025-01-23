module "security_groups" {
    source = "./modules/sg/"

    PROJECT_NAME  = var.PROJECT_NAME
    ENV           = var.ENV
    ALB_PORT      = var.ALB_PORT
    INSTANCE_PORT = var.INSTANCE_PORT
}

