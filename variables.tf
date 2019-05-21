variable "project" {
  description = "Project name to use on all resources created (VPC, ALB, etc)"
  type        = "string"
}

variable "environment" {
  description = "Deploy environment"
  type        = "string"
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = "map"
  default     = {}
}

variable "vpc_id" {
  description = "vpc id"
  type        = "string"
}

variable "subnets" {
  description = "subnets"
  type        = "list"
}

variable "access_cidrs" {
  description = "RDS access cidrs"
  type        = "list"
}

variable "database_name" {
  description = "RDS database name"
  type        = "string"
}

variable "username" {
  description = "RDS master username"
  type        = "string"
}

variable "password" {
  description = "RDS master password"
  type        = "string"
}

variable "allowed_security_groups" {
  description = "allowed security groups"
  type        = "list"
}

variable "allowed_security_groups_count" {
  description = "allowed security groups count"
  default     = 0
}

variable "replica_count" {
  description = "replica count"
  default     = 2
}

variable "instance_type" {
  description = "RDS instance type"
  type        = "string"
  default     = "db.t2.small"
}

variable "publicly_accessible" {
  description = "RDS public access"
  type        = "string"
  default     = "false"
}
