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
}
