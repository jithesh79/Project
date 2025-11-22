
variable "project" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }

resource "aws_db_subnet_group" "db_subnet" {
  name = "${var.project}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = { Name = "${var.project}-db-subnet-group" }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "wordpressdb"
  username             = "admin"
  password             = random_password.rnd.result
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}

resource "aws_security_group" "db_sg" {
  name = "${var.project}-db-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_password" "rnd" {
  length  = 16
  special = true
}
output "rds_endpoint" { value = aws_db_instance.mysql.address }
