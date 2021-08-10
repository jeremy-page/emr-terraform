resource "aws_emr_security_configuration" "emr_sec_config" {
  name = "emr-sec-config-${var.project_name}-${var.environment}"

  configuration = <<EOF
{
  "EncryptionConfiguration": {
    "AtRestEncryptionConfiguration": {
      "S3EncryptionConfiguration": {
        "EncryptionMode": "SSE-S3"
      },
      "LocalDiskEncryptionConfiguration": {
        "EncryptionKeyProviderType": "AwsKms",
        "AwsKmsKey": "${aws_kms_key.emr.arn}",
        "EnableEbsEncryption" : true
      }
    },
    "EnableAtRestEncryption": true,
    "EnableInTransitEncryption": false
  }
}
EOF
}

output "emr_sec_config_name" {
  value = aws_emr_security_configuration.emr_sec_config.name
}
