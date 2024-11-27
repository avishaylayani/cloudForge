variable "availability_zone" {
  description = "The availability zone in which to create the volume"
  type        = string
}

variable "ebs_size" {
    description = "The size of the volume"
    type = number
}

variable "ebs_tag_name" {
    description = "The name of the volume"  
    type = string
}

variable "instance_id" {
    description = "The id on the instance"
    type = string
}