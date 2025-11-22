
variable "project" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }

resource "aws_lb" "alb" {
  name = "${var.project}-alb"
  internal = false
  load_balancer_type = "application"
  subnets = var.public_subnet_ids
  enable_deletion_protection = false
  idle_timeout = 60
  tags = { Name = "${var.project}-alb" }
}

resource "aws_lb_target_group" "microservice" {
  name = "${var.project}-tg-micro"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check { path = "/" }
}

resource "aws_lb_target_group" "wordpress" {
  name = "${var.project}-tg-wp"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check { path = "/" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS listener created by ECS/ACM or by user; placeholder
output "alb_arn" { value = aws_lb.alb.arn }
output "alb_dns_name" { value = aws_lb.alb.dns_name }
output "target_group_microservice" { value = aws_lb_target_group.microservice.arn }
output "target_group_wordpress" { value = aws_lb_target_group.wordpress.arn }
