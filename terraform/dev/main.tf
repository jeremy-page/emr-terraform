# Bucket must exist before running
# Ensure it's private and has versioning enabled
# TODO: change var.aws_account_id to data.aws_caller_identity.current.account_id

terraform {
  backend "s3" {
    bucket  = "sb-demo-emr-terraform-state"
    key     = "emr-studio-emr/dev-emr-studio.tfstate"
    region  = "us-east-1"
    encrypt = "true"
  }
}

provider "aws" {
  region  = var.region
  version = "~> 2.65"
}

module "emr-resources" {
  source = "../modules/emr-resources"

  application         = var.application
  emr_subnet_id       = var.emr_subnet1
  environment         = var.environment
  git-origin          = var.git-origin
  ingress_bucket_name = module.s3-buckets.emr_ingress_bucket
  logging_bucket_name = module.s3-buckets.emr_logging_bucket
  owner               = var.owner
  pagerduty_email     = var.pagerduty_email
  project_name        = var.project_name
  sensitivity         = var.sensitivity
  vpc_id              = var.vpc_id
  vpn_security_group  = var.vpn_security_group
}

module "s3-buckets" {
  source = "../modules/s3-buckets"

  emr_kms_key = module.emr-resources.emr_kms_key_arn

  application     = var.application
  aws_account_id  = var.aws_account_id
  environment     = var.environment
  git-origin      = var.git-origin
  owner           = var.owner
  pagerduty_email = var.pagerduty_email
  project_name    = var.project_name
  sensitivity     = var.sensitivity
}

#module "notifier-lambda" {
#  source = "../modules/lambdas/event-notifier"
#
#  account_id = data.aws_caller_identity.current.account_id
#}

#module "emr-cw-alarm-lambda" {
#  source = "../modules/lambdas/cloudwatch-alarm-handler"
#
#  account_id = data.aws_caller_identity.current.account_id
#}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_caller_identity" "current" {
}
