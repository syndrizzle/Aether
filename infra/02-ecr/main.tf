resource "aws_ecr_repository" "apps" {
  for_each             = toset(["example-vote-app", "example-result-app", "example-worker-app"])
  name                 = each.value
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}
