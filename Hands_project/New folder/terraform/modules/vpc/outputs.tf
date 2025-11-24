output "private_subnet_cidrs" {
  value = aws_subnet.private[*].cidr_block
}
