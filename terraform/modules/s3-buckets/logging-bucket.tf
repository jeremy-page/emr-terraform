resource "aws_s3_bucket" "logging" {
  bucket = "${var.project_name}-emr-logs-${var.environment}"
  acl    = "log-delivery-write"

  lifecycle_rule {
    id      = "cleanup"
    enabled = true

    abort_incomplete_multipart_upload_days = 7

    expiration {
      days = var.log_bucket_retain_days
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.emr_kms_key
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    environment     = var.environment
    project         = var.project_name
    description     = "Aggregates logs from other buckets"
    owner           = var.owner,
    project         = var.project_name
    terraform       = "true"
    pagerduty-email = var.pagerduty_email
    application     = var.application
    sensitivity     = var.sensitivity
    git-origin      = var.git-origin
  }
}

resource "aws_s3_bucket_public_access_block" "logging_public_block" {
  bucket = aws_s3_bucket.logging.id

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}
