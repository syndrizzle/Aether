variable "cloudflare_account_id" {
  description = "The Cloudflare Account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare Zone ID for DNS records"
  type        = string
}

variable "domain_name" {
  description = "The base domain name for the application routes"
  type        = string
}
