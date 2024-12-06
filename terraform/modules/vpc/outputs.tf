output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main.id
}

# output "rds_subnet_group" {
#   value = aws_db_subnet_group.rds_group.name
# }