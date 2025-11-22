
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "interview-lab"
}

variable "vpc_create" {
  type    = bool
  default = true
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "deploy_s3_static" {
  type    = bool
  default = true
}
