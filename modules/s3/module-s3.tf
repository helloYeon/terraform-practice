##############################
# S3
##############################
#-----------------------------
# For Terraform
#-----------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.PROJECT_NAME}-${var.ENV}-terraform"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "enable" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}