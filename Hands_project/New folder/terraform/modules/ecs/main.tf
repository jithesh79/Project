
variable "project" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "alb_arn" { type = string }
variable "alb_target_group_for_microservice" { type = string }
variable "alb_target_group_for_wordpress" { type = string }

resource "aws_ecs_cluster" "this" {
  name = "${var.project}-ecs-cluster"
}

# ECR repositories (microservice)
resource "aws_ecr_repository" "micro" {
  name = "${var.project}-microservice"
  image_tag_mutability = "MUTABLE"
}

# Task definitions, services and IAM roles are left as placeholders for customization.
# For interview purposes, this module creates a cluster and ECR repo and wiring to ALB target groups
output "ecr_repo_url" { value = aws_ecr_repository.micro.repository_url }
output "ecs_cluster_name" { value = aws_ecs_cluster.this.name }
