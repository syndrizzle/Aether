locals {
  root_dir      = dirname(find_in_parent_folders("root.hcl"))
  env_file_path = "${local.root_dir}/env.yaml"
  env_vars      = yamldecode(file(local.env_file_path))
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.44.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.19.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.1.0"
    }
  }
}

provider "aws" {
  region = "${local.env_vars.aws_region}"
}

provider "cloudflare" {
  api_token = "${local.env_vars.cloudflare_api_token}"
}
EOF
}

inputs = local.env_vars
