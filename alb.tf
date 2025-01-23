module "alb" {
    source = "./modules/alb/"

    PROJECT_NAME = var.PROJECT_NAME
    ENV          = var.ENV
    ALB_PORT     = var.ALB_PORT

    alb_sg_id    = module.security_groups.alb_sg_id

}

