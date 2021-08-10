resource "aws_iam_role" "iam_for_emr_cleanup" {
  name                 = "qppar_sf_cw_handler_lambda"
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

# 
resource "aws_iam_role_policy_attachment" "lambda-cloudwatch" {
  role       = aws_iam_role.iam_for_emr_cleanup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "template_file" "permit_manage_cw_alarms_policy" {
  template = file("${path.module}/templates/permit_manage_cw_alarms_policy.json.tpl")

  vars = {
    account_id = var.account_id
  }
}

resource "aws_iam_policy" "permit_manage_cw_alarms" {
  name        = "permit_manage_cw_alarms"
  description = "Allow Managing Cloudwatch Alarms"
  path        = "/delegatedadmin/developer/"

  policy = data.template_file.permit_manage_cw_alarms_policy.rendered
}

resource "aws_iam_role_policy_attachment" "lambda-cloudwatch-alarms" {
  role       = aws_iam_role.iam_for_emr_cleanup.name
  policy_arn = aws_iam_policy.permit_manage_cw_alarms.arn
}

resource "aws_lambda_function" "cloudwatch_alarm_handler" {
  filename      = "../modules/lambdas/cloudwatch-alarm-handler/cloudwatch-alarm-handler.zip"
  function_name = "qppar-sf-emr-cloudwatch-event-handler"
  role          = aws_iam_role.iam_for_emr_cleanup.arn
  handler       = "cloudwatch-alarm-handler.lambda_handler"

  runtime = "python3.8"

}

resource "aws_lambda_function" "emr_cluster_terminator" {
  filename      = "../modules/lambdas/cloudwatch-alarm-handler/terminate-idle-emr-cluster.zip"
  function_name = "qppar-sf-emr-cluster-terminator"
  role          = aws_iam_role.iam_for_emr_cleanup.arn
  handler       = "terminate-idle-emr-cluster.lambda_handler"

  runtime = "python3.8"

}


