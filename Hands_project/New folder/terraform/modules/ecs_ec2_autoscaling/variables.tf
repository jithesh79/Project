variable "project" {}
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "instance_type" {}
variable "desired_capacity" {}
variable "min_size" {}
variable "max_size" {}
variable "ecs_cluster_name" {}
