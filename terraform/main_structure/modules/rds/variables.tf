variable "db_password" {
  description = "db_password"
  type        = string
}

variable "db_username" {
  description = "db_username"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security group IDs for the RDS(Same as instance)"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Subnets group for the relevant VPC"
  type = string
}