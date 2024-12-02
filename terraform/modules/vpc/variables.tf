variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone in which to create the subnet"
  type        = string
}