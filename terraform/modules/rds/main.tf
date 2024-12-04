resource "aws_db_instance" "postgres" {
  
  identifier             = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "12"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  username               = var.db_username
  password               = var.db_password
}
