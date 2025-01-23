module "instance" {
    source = "./modules/instance/"

    PROJECT_NAME      = var.PROJECT_NAME
    ENV               = var.ENV
    INSTANCE_PORT     = var.INSTANCE_PORT
    APP_INSTANCE_TYPE = var.APP_INSTANCE_TYPE

    instance_sg_id    = module.security_groups.instance_sg_id
}

