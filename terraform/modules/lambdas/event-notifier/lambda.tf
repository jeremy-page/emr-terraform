resource "aws_iam_role" "iam_for_emr_cleanup" {
  name = "qppar_sf_event_notifier_lambda"

  path                 = "/delegatedadmin/developer/"
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/cms-cloud-admin/developer-boundary-policy"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement": [
    {
      "Sid": "AllowLambdaAccess",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-cloudwatch" {
  role       = aws_iam_role.iam_for_emr_cleanup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "emr_event_notifier" {
  filename      = "../modules/lambdas/event-notifier/state-notifier.zip"
  function_name = "qppar-sf-emr-event-notifier"
  role          = aws_iam_role.iam_for_emr_cleanup.arn
  handler       = "state-notifier.lambda_handler"

  runtime = "python3.8"
  environment {
    variables = {
      "channel"  = "p-qpp-sub-alerts"
      "hook_url" = "https://hooks.slack.com/services/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"
    }
  }

}

# Pagerduty
resource "aws_lambda_function" "emr_pagerduty_notifier" {
  filename      = "../modules/lambdas/event-notifier/pagerduty-notifier.zip"
  function_name = "qppar-sf-emr-pagerduty-notifier"
  role          = aws_iam_role.iam_for_emr_cleanup.arn
  handler       = "pagerduty-notifier.lambda_handler"

  runtime = "python3.8"

}

data "template_file" "permit_ses_template" {
  template = file("${path.module}/templates/permit_ses.json.tpl")
  vars = {
    account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_iam_policy" "permit_ses" {
  name        = "permit_ses"
  description = "Allow Sending Email via SES"

  path = "/delegatedadmin/developer/"

  policy = data.template_file.permit_ses_template.rendered
}

resource "aws_iam_role_policy_attachment" "lambda-cloudwatch-alarms" {
  role       = aws_iam_role.iam_for_emr_cleanup.name
  policy_arn = aws_iam_policy.permit_ses.arn
}
