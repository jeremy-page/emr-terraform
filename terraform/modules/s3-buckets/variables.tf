# Varaibles specific to the S3 Bucket
variable "environment" {
  description = "The name of the environment"
}

variable "project_name" {
  description = "Name of the project"
}

variable "ingress_allow_role_arns" {
  description = "List of role arns allowed to get/put ingress bucket objects"
  default = [
    "arn:aws:iam::375727523534:role/qpp-ar-dev-nifi-InstanceIAMRole-19WCYXWSX3MKX",
    "arn:aws:iam::375727523534:role/qpp-ar-impl-nifi-InstanceIAMRole-C6OSXTDTZH1Y",
    "arn:aws:iam::375727523534:role/qpp-ar-prod-nifi-InstanceIAMRole-GOZ0CP7J9TCE",
  ]
}

variable "ingress_hcqar_allow_role_arns" {
  description = "List of role arns allowed to get/put ingress bucket objects"
  default     = null
}

variable "output_allow_role_arns" {
  description = "List of role arns allowed to get/put output bucket objects"
  default     = null
}

variable "emr_resources_allow_role_arns" {
  description = "List of role arns allowed to the emr resources bucket"
  default     = null
}

variable "snowball_allow_role_arns" {
  description = "List of role arns allowed to the emr resources bucket"
  default     = null
}


variable "log_bucket_retain_days" {
  default = 14
}

variable "emr_log_retain_days" {
  description = "how long to retain files in the logging bucket for"
  default     = 30
}

variable "emr_main_jar_retention_days" {
  default = 90
}

variable "aws_account_id" {
}

#TODO: Needs to go to a group
variable "eua_ids" {
  default = [
    "PIXF",
    "J5D6",
    "BLEL",
    "WFMQ",
    "AWRA",
    "MW31",
    "SRYO",
    "CHXM",
    "BWEP"
  ]
}

variable "emr_kms_key" {
  description = "KMS key for EMR to use for data encryption"
}

variable "owner" {}

variable "pagerduty_email" {}

variable "application" {}

variable "sensitivity" {}

variable "git-origin" {}
