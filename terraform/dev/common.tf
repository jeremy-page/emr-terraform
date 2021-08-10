# Contains common resources like ECR to be used across all accounts
resource "aws_ecr_repository" "scoring-engine-express" {
  name                 = "scoring-engine-express"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
