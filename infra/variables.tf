variable "github_pat" {
  description = "GitHub Personal Access Token for CodeBuild authentication"
  type        = string
  sensitive   = true
}

variable "github_repo_url" {
  description = "The HTTPS URL of the target GitHub repository"
  type        = string
  default     = "https://github.com/syndrizzle/devops-task-sem6.git"
}

variable "alert_email_address" {
  description = "The email address that will receive EKS CloudWatch alerts"
  type        = string
}

variable "local_workstation_cidr" {
  description = "The CIDR block of your local machine to allow access to the EKS public API (e.g., '203.0.113.50/32')"
  type        = string
}

# Cloudflare Specifics
variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID (for your domain)"
  type        = string
}

variable "domain_name" {
  description = "Your root domain name (e.g., example.com)"
  type        = string
}
