resource "aws_codecommit_repository" "cc-repo" {
    description     = "my repo in terraform"
    repository_name = "Cloudbootcamp-nicolas-bayer-Repository"
    tags            = {}
    tags_all        = {}
}

