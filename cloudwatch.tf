resource "aws_cloudwatch_log_group" "cw_group" {
  name = "cloudtrail-lg"
}

// Unauthorized API Access

resource "aws_cloudwatch_metric_alarm" "Unauth_API_Calls_Alarm" {
  alarm_name = "unauthorized_api_calls"
  alarm_description = "A CloudWatch Alarm that triggers if Multiple unauthorized actions or logins attempted."
  metric_name = "UnauthorizedAttemptCount"
  namespace = "CloudTrailMetrics"
  statistic = "Sum"
  period = "60"
  threshold = "1"
  evaluation_periods = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions = [ aws_sns_topic.user_alerts.arn ]
  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "UAC_MetricFilter" {
  log_group_name = aws_cloudwatch_log_group.cw_group.name //"cloudtrail-lg"
  pattern = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"
  name = "UnauthorizedAttemptCount"

  metric_transformation {
    name = "UnauthorizedAttemptCount"
    value = "1"
    namespace = "CloudTrailMetrics"
  }
}

// Management Console Sign-In without MFA

resource "aws_cloudwatch_metric_alarm" "Non_MFA_Login_Alarm" {
  alarm_name = "no_mfa_console_logins"
  alarm_description = "A CloudWatch Alarm that triggers if there is a Management Console sign-in without MFA."
  metric_name = "ConsoleSigninWithoutMFA"
  namespace = "CloudTrailMetrics"
  statistic = "Sum"
  period = "60"
  threshold = "1"
  evaluation_periods = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions = [ aws_sns_topic.user_alerts.arn ]
  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "NML_MetricFilter" {
  log_group_name = aws_cloudwatch_log_group.cw_group.name //"cloudtrail-lg"
  pattern = "{($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") && ($.responseElements.ConsoleLogin != \"Failure\") && ($.additionalEventData.SamlProviderArn NOT EXISTS) }"
  name = "ConsoleSigninWithoutMFA"

  metric_transformation {
    name = "ConsoleSigninWithoutMFA"
    value = "1"
    namespace = "CloudTrailMetrics"
  }

}

// Usage of the root account 

resource "aws_cloudwatch_metric_alarm" "Root_Usage_Alarm" {
  alarm_name = "root_account_login"
  alarm_description = "A CloudWatch Alarm that triggers if a root user uses the account."
  metric_name = "RootUserEventCount"
  namespace = "CloudTrailMetrics"
  statistic = "Sum"
  period = "60"
  threshold = "1"
  evaluation_periods = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions = [ aws_sns_topic.user_alerts.arn ]
  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "RU_MetricFilter" {
  log_group_name = aws_cloudwatch_log_group.cw_group.name //"cloudtrail-lg"
  pattern = "{ ($.userIdentity.type = \"Root\") && ($.userIdentity.invokedBy NOT EXISTS) && ($.eventType != \"AwsServiceEvent\") }"
  name = "RootUserEventCount"

  metric_transformation {
    name = "RootUserEventCount"
    value = "1"
    namespace = "CloudTrailMetrics"
  }

}