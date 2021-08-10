# Watch for EMR clusters starting
resource "aws_cloudwatch_event_rule" "emr-cluster-started" {
  name        = "emr-cluster-started"
  description = "Capture each EMR Cluster at boot"

  event_pattern = <<EOF
  {
   "source": [
     "aws.emr"
   ],
   "detail-type": [
     "EMR Cluster State Change"
   ],
    "detail": {
      "state": [
        "STARTING"
      ]
    }
  }
EOF
}
# Create event target
resource "aws_cloudwatch_event_target" "cloudwatch-event-handler" {
  rule      = aws_cloudwatch_event_rule.emr-cluster-started.name
  target_id = "cloudwatch-event-handler-target"
  arn       = aws_lambda_function.cloudwatch_alarm_handler.arn
}
# Give CloudWatch access to invoke the lambda
resource "aws_lambda_permission" "allow_cloudwatch_to_call_handler_lambda" {
  statement_id  = "AllowExecutionFromCloudWatchOnStartup"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_alarm_handler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.emr-cluster-started.arn
}

# Watch for stopped EMR Clusters
resource "aws_cloudwatch_event_rule" "emr-cluster-terminated" {
  name        = "emr-cluster-terminated"
  description = "Capture each EMR Cluster when shutdown"

  event_pattern = <<EOF
  {
    "source": [
     "aws.emr"
    ],
    "detail-type": [
     "EMR Cluster State Change"
    ],
    "detail": {
      "state": [
        "TERMINATED",
        "TERMINATED_WITH_ERRORS"
      ]
    }
  }
EOF
}

# Create event target
resource "aws_cloudwatch_event_target" "cloudwatch-event-handler-terminate" {
  rule      = aws_cloudwatch_event_rule.emr-cluster-terminated.name
  target_id = "cloudwatch-event-handler-target"
  arn       = aws_lambda_function.cloudwatch_alarm_handler.arn
}
# Give CloudWatch access to invoke the lambda
resource "aws_lambda_permission" "allow_cloudwatch_to_call_handler_lambda_terminate" {
  statement_id  = "AllowExecutionFromCloudWatchOnShutdown"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_alarm_handler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.emr-cluster-terminated.arn
}

resource "aws_lambda_permission" "sns_cloudwatchlog_multi" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.emr_cluster_terminator.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.clusters_idle.arn
}
