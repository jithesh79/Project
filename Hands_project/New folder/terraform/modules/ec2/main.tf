
variable "project" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }
variable "instance_type" { type = string }

resource "aws_instance" "instance1" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[0]
  user_data = file("${path.module}/user_data/nginx_docker_userdata.sh")
  tags = { Name = "${var.project}-ec2-1" }
}

resource "aws_instance" "instance2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[1]
  user_data = file("${path.module}/user_data/nginx_docker_userdata.sh")
  tags = { Name = "${var.project}-ec2-2" }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
output "ec2_public_ips" { value = [aws_instance.instance1.public_ip, aws_instance.instance2.public_ip] }
