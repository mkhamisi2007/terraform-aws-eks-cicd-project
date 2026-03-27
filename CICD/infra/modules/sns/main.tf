resource "aws_sns_topic" "approval" {
  name = var.topic_name
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.approval.arn
  protocol  = "email"
  endpoint  = var.email
}
