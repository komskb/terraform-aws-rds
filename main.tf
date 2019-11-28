locals {
  publicly_accessible = var.publicly_accessible == "true" ? true : false
}

###################
# RDS
###################

module "rds" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "v2.9.0"

  name                            = format("%s-%s-rds", var.project, var.environment)
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.12"
  vpc_id                          = var.vpc_id
  subnets                         = var.subnets
  allowed_security_groups         = var.allowed_security_groups
  apply_immediately               = true
  skip_final_snapshot             = true
  db_parameter_group_name         = "default.aurora-mysql5.7"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name

  replica_count = length(var.subnets)
  instance_type = var.instance_type

  //require customization
  publicly_accessible = local.publicly_accessible

  //require customization
  database_name = var.database_name
  username      = var.username
  password      = var.password

  tags = merge(
    var.tags,
    {
      "Project" = var.project
    },
  )
}

resource "aws_rds_cluster_parameter_group" "this" {
  name        = format("%s-%s-rds-pg", var.project, var.environment)
  family      = "aurora-mysql5.7"
  description = "utf8mb4_unicode_ci"

  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_unicode_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_unicode_ci"
    apply_method = "immediate"
  }

  tags = merge(
    var.tags,
    {
      "Name"    = format("%s-%s-rds-pg", var.project, var.environment)
      "Project" = var.project
    },
  )
}

resource "aws_security_group_rule" "user_allow_access" {
  type              = "ingress"
  from_port         = module.rds.this_rds_cluster_port
  to_port           = module.rds.this_rds_cluster_port
  protocol          = "tcp"
  cidr_blocks       = var.access_cidrs
  security_group_id = module.rds.this_security_group_id
}

resource "aws_security_group_rule" "allow_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.rds.this_security_group_id
}

