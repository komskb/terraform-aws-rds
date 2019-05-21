# KOMSKB Framework Terraform AWS-RDS module 

AWS RDS를 생성하는 Terraform 모듈 입니다.

내부적으로 사용하는 리소스 및 모듈:

* [AURORA](https://github.com/terraform-aws-modules/terraform-aws-rds-aurora)
* [Rds Cluster Parameter Group](https://www.terraform.io/docs/providers/aws/r/rds_cluster_parameter_group.html)
* [Security Group Rule](https://www.terraform.io/docs/providers/aws/r/security_group_rule.html)

## Usage

```hcl
module "rds" {
  source = "komskb/terraform-module-rds"

  project = "${var.project}"
  environment = "${var.environment}"
  subnets = ["${module.vpc.database_subnets}"]
  vpc_id = "${module.vpc.vpc_id}"
  allowed_security_groups = ["${module.alb.security_group_id}"]
  allowed_security_groups_count = 1

  replica_count = 2
  instance_type = "${var.rds_instance_type}"

  //require customization
  publicly_accessible = "${local.rds_use_public_access}"
  access_cidrs = ["${var.rds_access_cidrs}"]

  //require customization
  database_name = "${var.rds_database_name}"
  username = "${var.rds_master_username}"
  password = "${var.rds_master_password}"

  tags = {
    Name = "${format("%s-%s-rds", var.project, var.environment)}"
    Terraform = "${var.terraform_repo}"
    Environment = "${var.environment}"
  }
}
```

## Terraform version

Terraform version 0.11.13 or newer is required for this module to work.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| access\_cidrs | RDS access cidrs | list | n/a | yes |
| allowed\_security\_groups | allowed security groups | list | n/a | yes |
| allowed\_security\_groups\_count | allowed security groups count | string | `"0"` | no |
| database\_name | RDS database name | string | n/a | yes |
| environment | Deploy environment | string | n/a | yes |
| instance\_type | RDS instance type | string | `"db.t2.small"` | no |
| password | RDS master password | string | n/a | yes |
| project | Project name to use on all resources created (VPC, ALB, etc) | string | n/a | yes |
| publicly\_accessible | RDS public access | string | `"false"` | no |
| replica\_count | replica count | string | `"2"` | no |
| subnets | subnets | list | n/a | yes |
| tags | A map of tags to use on all resources | map | `{}` | no |
| username | RDS master username | string | n/a | yes |
| vpc\_id | vpc id | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| this\_rds\_cluster\_database\_name | Name for an automatically created database on cluster creation |
| this\_rds\_cluster\_endpoint | The cluster endpoint |
| this\_rds\_cluster\_id | The ID of the cluster |
| this\_rds\_cluster\_instance\_endpoints | A list of all cluster instance endpoints |
| this\_rds\_cluster\_master\_password | The master password |
| this\_rds\_cluster\_master\_username | The master username |
| this\_rds\_cluster\_port | The port |
| this\_rds\_cluster\_reader\_endpoint | The cluster reader endpoint |
| this\_security\_group\_id | The security group ID of the cluster |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Authors

Module is maintained by [komskb](https://github.com/komskb).

## License

MIT licensed. See LICENSE for full details.