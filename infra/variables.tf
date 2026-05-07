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
