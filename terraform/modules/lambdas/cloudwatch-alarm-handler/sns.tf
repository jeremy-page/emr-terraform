resource "aws_sns_topic" "clusters_idle" {
  name = "clusters-idle-for-an-hour"
}

resource "aws_sns_topic_subscription" "sns-to-lambda" {
  topic_arn = aws_sns_topic.clusters_idle.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.emr_cluster_terminator.arn

}

