output "iam_emr_ec2_role" {
  value = aws_iam_role.emr_ec2_role.arn
}

output "iam_emr_service_role" {
  value = aws_iam_role.emr_service_role.arn
}

#output "emr_env" {
#  value = <<EOF
#  TODO: Fix bucket here
#- EMR_LOG_URI=s3://${aws_s3_bucket.logging.name}/${var.project_name}/${var.environment}/emr/
#- EMR_SERVICE_ROLE_ARN=${aws_iam_role.emr_service_role.arn}
#- EMR_EC2_INSTANCE_PROFILE=${aws_iam_instance_profile.emr_ec2_role.arn}
#- EMR_EC2_SUBNET_ID=${var.emr_subnet_id}
#- EMR_SLAVE_ADDL_SEC_GROUP=${aws_security_group.emr_worker_additional.id}
#- EMR_MASTER_ADDL_SEC_GROUP=${aws_security_group.emr_master_additional.id}
#- EMR_NAME=${var.environment}-${var.project_name}-emr
#- EMR_SECURITY_CONFIGURATION=${aws_emr_security_configuration.emr_sec_config.name}
#EOF
#}

output "emr_kms_key_arn" {
  value = aws_kms_key.emr.arn
}
