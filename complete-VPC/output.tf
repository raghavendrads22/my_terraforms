output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "sg_rds" {
  value = aws_security_group.rds_sg.id
}
