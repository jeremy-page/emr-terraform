# Watch for EMR clusters starting
resource "aws_cloudwatch_event_rule" "emr-cluster-state-change" {
  name        = "emr-cluster-state-change"
  description = "Capture each EMR Cluster state change"

  event_pattern = <<EOF
  {
   "source": [
     "aws.emr"
   ]
  }
EOF
}
# Create event target
resource "aws_cloudwatch_event_target" "emr-state-handler" {
  rule      = aws_cloudwatch_event_rule.emr-cluster-state-change.name
  target_id = "cloudwatch-event-handler-target"
  arn       = aws_lambda_function.emr_event_notifier.arn
}
# Give CloudWatch access to invoke the lambda
resource "aws_lambda_permission" "allow_cloudwatch_to_call_handler_lambda" {
  statement_id  = "AllowExecutionFromCloudWatchOnStartup"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.emr_event_notifier.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.emr-cluster-state-change.arn
}
# Pagerduty
resource "aws_cloudwatch_event_target" "emr-pagerduty-handler" {
  rule      = aws_cloudwatch_event_rule.emr-cluster-state-change.name
  target_id = "cloudwatch-event-handler-target"
  arn       = aws_lambda_function.emr_pagerduty_notifier.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_pagerduty_lambda" {
  statement_id  = "AllowExecutionFromCloudWatchOnStartup"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.emr_pagerduty_notifier.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.emr-cluster-state-change.arn
}
