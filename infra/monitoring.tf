module "kms" {
  source                  = "terraform-aws-modules/kms/aws"
  version                 = "~> 4.0"
  description             = "KMS Key for EKS CloudWatch to SNS alerts"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  aliases                 = ["eks-alerts-key"]
  key_statements = [
    {
      sid    = "AllowCloudWatchForCMK"
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey*"
      ]
      resources = ["*"]
      principals = [
        {
          type        = "Service"
          identifiers = ["cloudwatch.amazonaws.com"]
        }
      ]
    }
  ]
}
resource "aws_sns_topic" "eks_alerts" {
  name              = "eks-alerts-topic"
  kms_master_key_id = module.kms.key_id
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
