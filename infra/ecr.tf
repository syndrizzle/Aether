resource "aws_ecr_repository" "apps" {
  for_each             = toset(["example-vote-app", "example-result-app", "example-worker-app"])
  name                 = each.value
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
