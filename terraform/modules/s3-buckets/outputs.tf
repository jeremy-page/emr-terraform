output "emr_logging_bucket" {
  value = aws_s3_bucket.logging.id
}

output "emr_ingress_bucket" {
  value = aws_s3_bucket.ingress.id
}
