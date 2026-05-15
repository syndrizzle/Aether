locals {
  env_file_path = "${get_terragrunt_dir()}/env.yaml"
  env_vars = fileexists(local.env_file_path) ? yamldecode(file(local.env_file_path)) : run_cmd("--terragrunt-quiet", "sh", "-c", "echo 'ERROR: env.yaml not found. Please copy env.example.yaml to env.yaml and configure it before running Terragrunt.' >&2 && exit 1")
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
