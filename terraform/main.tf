module "key_pair" {
  source          = "./modules/key_pair"
  key_name        = var.key_name
  public_key_path = var.public_key_path
}

module "vpc" {
  source            = "./modules/vpc"
  cidr_block        = var.vpc_cidr_block
  availability_zone = var.availability_zone
}

module "security_group" {
  source        = "./modules/security_group"
  vpc_id        = module.vpc.vpc_id
  security_name = var.security_group_name
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}

module "instance" {
  source                 = "./modules/instance"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  key_name               = module.key_pair.key_name
  vpc_security_group_ids = [module.security_group.security_group_id]
  instances              = var.instances
  availability_zone      = var.availability_zone
  subnet_id              = module.vpc.subnet_id
}

# module "local_file" {
#   source   = "./modules/local_file"
#   content  = module.instance.instance_inventory
#   filename = var.inventory_filename
# }

module "ebs_volume" {
  source = "./modules/ebs_volume"
  availability_zone = var.availability_zone
  ebs_tag_name = var.ebs_tag_name
  ebs_size = var.ebs_size
  instance_id = module.instance.instance_id
}