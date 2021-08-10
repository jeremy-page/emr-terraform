variable "region" {
  description = "The AWS region to use"
  type        = string
}

variable "project_name" {
  description = "Team or Project"
  type        = string
}

variable "environment" {
  type = string
}

variable "aws_account_id" {
  description = "AWS Account ID Number"
  type        = string
}

variable "emr_subnet_id" {
  description = "Subnet for running EMR instances"
  type        = string
}

variable "vpc_id" {
  description = "the VPC you want to use"
  type        = string
}

variable "vpn_security_group" {}

variable "owner" {}

variable "pagerduty_email" {}

variable "application" {}

variable "sensitivity" {}

variable "git-origin" {}

variable "emr_subnet1" {}

variable "vpn_cidr" {}

