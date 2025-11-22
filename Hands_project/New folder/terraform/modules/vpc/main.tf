
variable "project" { type = string }
variable "create_vpc" { type = bool }
variable "cidr" { default = "10.0.0.0/16" }

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0
  cidr_block = var.cidr
  tags = { Name = "${var.project}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  count = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.this[0].id
  tags = { Name = "${var.project}-igw" }
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.this[0].id
  cidr_block = cidrsubnet(var.cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { Name = "${var.project}-public-${count.index}" }
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.this[0].id
  cidr_block = cidrsubnet(var.cidr, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { Name = "${var.project}-private-${count.index}" }
}

data "aws_availability_zones" "available" {}
output "vpc_id" { value = aws_vpc.this[0].id }
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
