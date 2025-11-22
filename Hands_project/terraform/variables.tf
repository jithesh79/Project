variable "db_username" {}
variable "db_password" {}
variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "ecs_subnet_cidrs" {
  type = list(string)
}
