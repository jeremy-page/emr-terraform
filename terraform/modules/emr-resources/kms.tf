resource "aws_kms_key" "emr" {
  description = "For encrypting EMR disks"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ct-ado-qppscoring-application-admin"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.emr_service_role.arn}",
                    "${aws_iam_role.emr_ec2_role.arn}"
                ]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ListResourceTags",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:GetKeyPolicy",
                "kms:GetKeyRotationStatus",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.emr_service_role.arn}",
                    "${aws_iam_role.emr_ec2_role.arn}"
                ]
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
EOF
}


resource "aws_kms_alias" "emr" {
  name          = "alias/${var.project_name}-${var.environment}-emr"
  target_key_id = aws_kms_key.emr.key_id
}
