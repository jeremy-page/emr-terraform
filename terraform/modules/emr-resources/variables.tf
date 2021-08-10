variable "environment" {
  description = "The name of the environment"
}

variable "project_name" {
  description = "Name of the project"
}

variable "vpc_id" {}

variable "emr_subnet_id" {}

variable "create_config_map" { default = true }

variable "emr_task_worker_count" { default = 1 }

variable "emr_task_worker_type" { default = "c5.2xlarge" }

variable "vpn_security_group" {}

variable "owner" {}

variable "pagerduty_email" {}

variable "application" {}

variable "sensitivity" {}

variable "git-origin" {}

variable "ingress_bucket_name" {}

variable "logging_bucket_name" {}

variable "account_id" {}
