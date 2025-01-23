module "s3" {
    source = "./modules/s3/"

    PROJECT_NAME = var.PROJECT_NAME
    ENV          = var.ENV
}

