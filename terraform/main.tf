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
  instance               = var.instance
  availability_zone      = var.availability_zone
  subnet_id              = module.vpc.subnet_id
  user_data_script       = var.k8s_install_path
  username               = var.username
  private_key_path       = var.private_key_path
}

# module "rds" {  ### Still not working
#   source                 = "./modules/rds"
#   vpc_security_group_ids = [module.security_group.security_group_id]
#   db_username            = var.db_username
#   db_password            = var.db_password
#   db_subnet_group_name   = module.vpc.rds_subnet_group
# }
# module "ebs" {
#   source      = "./modules/ebs"
#   instance_id = module.instance.instance_id
# }
module "local_file" {
  source   = "./modules/local_file"
  content  = module.instance.instance_inventory
  filename = var.inventory_filename
}

# module "s3_buckets" {
#   source     = "./modules/s3_buckets"
#   s3_buckets = var.s3_buckets

# }