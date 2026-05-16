variable "cluster_name" {
  description = "The name of the EKS cluster to monitor"
  type        = string
}

variable "alert_email_address" {
  description = "The email address to send CloudWatch SNS alerts to"
  type        = string
}
