
output "alb_dns" {
  description = "ALB DNS name"
  value = module.alb.alb_dns_name
}
