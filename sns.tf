variable "email_address" {
  type = string
  description = "Please enter your email address for the alerts"
}

resource "aws_sns_topic" "user_alerts" {
  name = "user-alerts"
}

resource "aws_sns_topic_subscription" "alert_emails" {
  topic_arn = aws_sns_topic.user_alerts.arn
  protocol = "email"
  endpoint = var.email_address //set your email address
}