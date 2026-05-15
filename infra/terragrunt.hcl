locals {
  env_vars = yamldecode(file("${get_terragrunt_dir()}/env.yaml"))
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.env_vars.aws_region}"
}

provider "cloudflare" {
  api_token = "${local.env_vars.cloudflare_api_token}"
}
EOF
}

inputs = local.env_vars
