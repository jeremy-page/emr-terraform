# Bucket for bringing data into EMR
resource "aws_s3_bucket" "ingress" {
  bucket = "scoring-data-${var.project_name}-${var.environment}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.emr_kms_key
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.logging.id
    target_prefix = "logs/${var.project_name}/${var.environment}/scoring-data/"
  }

  lifecycle_rule {
    id      = "default-lifecycle"
    enabled = false

    expiration {
      days                         = 0
      expired_object_delete_marker = false
    }
  }

  tags = {
    environment     = var.environment
    project         = var.project_name
    owner           = var.owner,
    project         = var.project_name
    terraform       = "true"
    pagerduty-email = var.pagerduty_email
    application     = var.application
    sensitivity     = var.sensitivity
    git-origin      = var.git-origin
  }
}

resource "aws_s3_bucket_public_access_block" "ingress_public_block" {
  bucket = aws_s3_bucket.ingress.id

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_policy" "ingress" {
  count  = var.ingress_allow_role_arns != null ? 1 : 0
  bucket = aws_s3_bucket.ingress.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ingress",
    "Statement": [
        {
            "Sid": "AddAdminS3Access",
            "Effect": "Allow",
            "Principal": {
                "AWS": ${jsonencode(var.ingress_allow_role_arns)}
            },
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${aws_s3_bucket.ingress.arn}/*",
                "${aws_s3_bucket.ingress.arn}"
            ]
        },
        {
            "Sid": "DenyUnencryptedCommunication",
            "Action": "s3:*",
            "Effect": "Deny",
            "Resource": [
                "${aws_s3_bucket.ingress.arn}/*",
                "${aws_s3_bucket.ingress.arn}"  
              ],
            "Condition": {
              "Bool": {
                "aws:SecureTransport": "false"
              }
            },
            "Principal": "*"
      }
  ]
}
POLICY
}
