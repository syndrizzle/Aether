# Create the SNS Topic
resource "aws_sns_topic" "eks_alerts" {
  name = "eks-alerts-topic"
}
resource "aws_sns_topic_subscription" "eks_alerts_email" {
  topic_arn = aws_sns_topic.eks_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email_address
}
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "eks-high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors EKS node CPU utilization"

  dimensions = {
    ClusterName = module.eks.cluster_name
  }
  alarm_actions = [aws_sns_topic.eks_alerts.arn]
  ok_actions    = [aws_sns_topic.eks_alerts.arn]
}
