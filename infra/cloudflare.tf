resource "random_password" "tunnel_secret" {
  length = 64
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "eks_tunnel" {
  account_id    = var.cloudflare_account_id
  name          = "eks-voting-app-tunnel"
  tunnel_secret = base64encode(random_password.tunnel_secret.result)
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "eks_tunnel_token" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.eks_tunnel.id
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "eks_tunnel_routing" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.eks_tunnel.id
  config = {
    ingress = [
      {
        hostname = "vote.${var.domain_name}"
        service  = "http://vote.default.svc.cluster.local:80"
      },
      {
        hostname = "result.${var.domain_name}"
        service  = "http://result.default.svc.cluster.local:80"
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

resource "cloudflare_dns_record" "vote_dns" {
  zone_id = var.cloudflare_zone_id
  name    = "vote.${var.domain_name}"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.eks_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}


resource "cloudflare_dns_record" "result_dns" {
  zone_id = var.cloudflare_zone_id
  name    = "result.${var.domain_name}"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.eks_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

output "cloudflare_tunnel_token" {
  value     = data.cloudflare_zero_trust_tunnel_cloudflared_token.eks_tunnel_token.token
  sensitive = true
}

resource "kubernetes_secret_v1" "cloudflare_tunnel" {
  metadata {
    name      = "cloudflare-tunnel-token"
    namespace = "default"
  }
  data = {
    TUNNEL_TOKEN = data.cloudflare_zero_trust_tunnel_cloudflared_token.eks_tunnel_token.token
  }
  depends_on = [module.eks]
}
