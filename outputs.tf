# output "public_ip" {
#   value = aws_instance.name.public_ip
#   description = "APPLE_BANANA_PINE"
# }

output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "The domain name of the load balance"
}