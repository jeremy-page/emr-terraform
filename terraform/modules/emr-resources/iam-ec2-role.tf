data "aws_caller_identity" "current" {}

resource "aws_iam_role" "emr_ec2_role" {
  name                 = "emr-ec2-role-${var.project_name}-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "template_file" "emr_ec2_policy" {
  template = file("${path.module}/templates/emr_ec2_policy.json.tpl")

  vars = {
    env            = var.environment
    ingress_bucket = var.ingress_bucket_name
    logging_bucket = var.logging_bucket_name
  }
}

resource "aws_iam_policy" "emr_ec2" {
  name        = "emr-ec2-${var.project_name}-${var.environment}"
  description = "EMR EC2 Policy"

  policy = data.template_file.emr_ec2_policy.rendered
}

resource "aws_iam_role_policy_attachment" "emr_ec2" {
  role       = aws_iam_role.emr_ec2_role.name
  policy_arn = aws_iam_policy.emr_ec2.arn
}

resource "aws_iam_instance_profile" "emr_ec2_role" {
  name = "emr-ec2-role-${var.project_name}-${var.environment}"
  role = aws_iam_role.emr_ec2_role.name
}
