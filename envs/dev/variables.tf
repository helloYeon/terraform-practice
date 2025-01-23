variable "PROFILE" {
  description = "The AWS CLI profile name used for authentication"
  type        = string
}

variable "PROJECT_NAME" {
  description = "The name of the project"
  type        = string
}

variable "ENV" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "REGION" {
  description = "The AWS region where the resources will be deployed"
  type        = string
}

variable "ALB_PORT" {
  description = "The port number used for the Application Load Balancer security group (e.g., 80)"
  type        = number
}
variable "INSTANCE_PORT" {
  description = "The port number used for the instance security group (e.g., 8080)"
  type        = number
}
variable "APP_INSTANCE_TYPE" {
  description = "The Instance type of Application"
  type        = string
}