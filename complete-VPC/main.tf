
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"
  name    = "${var.project_name}-rds-${var.stage}"

  cidr = "172.32.0.0/16"

  azs                    = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets        = ["172.32.0.0/20", "172.32.16.0/20", "172.32.32.0/20"]
  public_subnets         = ["172.32.48.0/20", "172.32.64.0/20", "172.32.80.0/20"]
  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true
  enable_dns_support     = true

  public_subnet_tags = {
    Name = "subnet-${var.project_name}-rds-${var.stage}-public"
  }

  private_subnet_tags = {
    Name = "subnet-${var.project_name}-rds-${var.stage}-private"
  }

  public_route_table_tags = {
    Name = "rtl-${var.project_name}-rds-${var.stage}-public"
  }

  private_route_table_tags = {
    Name = "rtl-${var.project_name}-rds-${var.stage}-private"
  }

  private_subnet_suffix = "private"
  public_subnet_suffix  = "public"

  tags = {
    Name = "${var.project_name}-rds-${var.stage}"
  }
}

resource "aws_security_group" "rds_sg" {
  depends_on = ["module.vpc"]

  name        = "${var.project_name}-rds-sg-${var.stage}"
  description = "security group for RDS access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #self      = true
    cidr_blocks = ["49.206.43.174/32"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg-${var.stage}"
  }
}
