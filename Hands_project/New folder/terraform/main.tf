
# Root terraform that wires modules together.
locals {
  name = var.project_name
}

module "vpc" {
  source = "./modules/vpc"
  project = local.name
  create_vpc = var.vpc_create
}

module "alb" {
  source = "./modules/alb"
  project = local.name
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "rds" {
  source = "./modules/rds"
  project = local.name
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "ecs" {
  source = "./modules/ecs"
  project = local.name
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  alb_arn = module.alb.alb_arn
  alb_target_group_for_microservice = module.alb.target_group_microservice
  alb_target_group_for_wordpress = module.alb.target_group_wordpress
}

module "ec2" {
  source = "./modules/ec2"
  project = local.name
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  instance_type = var.instance_type
}
