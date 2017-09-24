# Define Container Registry
resource "aws_ecr_repository" "ecr" {
  name = "wordpress"
}
