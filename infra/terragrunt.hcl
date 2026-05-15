locals {
  env_file_path = "${get_terragrunt_dir()}/env.yaml"
  env_vars = fileexists(local.env_file_path) ? yamldecode(file(local.env_file_path)) : run_cmd("--terragrunt-quiet", "sh", "-c", "echo 'ERROR: env.yaml not found. Please copy env.example.yaml to env.yaml and configure it before running Terragrunt.' >&2 && exit 1")
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
