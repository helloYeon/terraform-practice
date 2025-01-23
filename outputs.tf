output "instance_sg_id" {
  description = "Security group ID for the instance"
  value       = module.security_groups.instance_sg_id
}

output "alb_sg_id"      {
  description = "Security group ID for the ALB"
  value  = module.security_groups.alb_sg_id
}

