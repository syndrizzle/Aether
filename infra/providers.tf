terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.44.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.8.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.19.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.1.0"
    }

  }
}

provider "aws" {
  region = "ap-south-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}
