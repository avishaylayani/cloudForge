output "ebs" {
  description = "EBS ID generated from the module"
  value = aws_ebs_volume.cicd.id
}
