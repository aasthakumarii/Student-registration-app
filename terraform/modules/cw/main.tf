resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = var.name
  retention_in_days = 1
}

resource "aws_sns_topic" "alerts" {
  name = "ecs-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.endpoint
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {

  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}