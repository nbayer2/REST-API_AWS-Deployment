resource "aws_codebuild_project" "cb-build" {
    badge_enabled          = false
    build_timeout          = 60
    encryption_key         = "arn:aws:kms:eu-central-1:324176193308:alias/aws/s3"
    name                   = "Cloudbootcamp-nicolas-bayer-build"
    project_visibility     = "PRIVATE"
    queued_timeout         = 480
    service_role           = "arn:aws:iam::324176193308:role/service-role/codebuild-Cloudbootcamp-nicolas-bayer-build-service-role"
    source_version         = "refs/heads/master"
    tags                   = {}
    tags_all               = {}

    artifacts {
        encryption_disabled    = false
        override_artifact_name = false
        type                   = "NO_ARTIFACTS"
    }

    cache {
        modes = []
        type  = "NO_CACHE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/standard:4.0"
        image_pull_credentials_type = "CODEBUILD"
        privileged_mode             = true
        type                        = "LINUX_CONTAINER"

        environment_variable {
            name  = "AWS_DEFAULT_REGION"
            type  = "PLAINTEXT"
            value = "eu-central-1"
        }
        environment_variable {
            name  = "IMAGE_REPO_NAME"
            type  = "PLAINTEXT"
            value = "cloudbootcamp_nicolas_bayer_containerregistery"
        }
        environment_variable {
            name  = "IMAGE_TAG"
            type  = "PLAINTEXT"
            value = "latest"
        }
        environment_variable {
            name  = "AWS_ACCOUNT_ID"
            type  = "PLAINTEXT"
            value = "324176193308"
        }
    }

    logs_config {
        cloudwatch_logs {
            status = "ENABLED"
        }

        s3_logs {
            encryption_disabled = false
            status              = "DISABLED"
        }
    }

    source {
        git_clone_depth     = 1
        insecure_ssl        = false
        location            = "https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/Cloudbootcamp-nicolas-bayer-Repository"
        report_build_status = false
        type                = "CODECOMMIT"

        git_submodules_config {
            fetch_submodules = false
        }
    }
}






# resource "aws_codebuild_project" "cb-build" {
#   name          = "Cloudbootcamp-nicolas-bayer-build"
#   description   = "codebuild-pipeline-terra"
#   service_role  = aws_iam_role.example.arn

#   artifacts {
#     type = "NO_ARTIFACTS"
#   }

#   environment {
#     compute_type                = "BUILD_GENERAL1_SMALL"
#     image                       = "aws/codebuild/standard:1.0"
#     type                        = "LINUX_CONTAINER"
#     image_pull_credentials_type = "CODEBUILD"
#   }

#   source {
#     type            = "GITHUB"
#     location        = "https://github.com/mitchellh/packer.git"
#     git_clone_depth = 1

#     git_submodules_config {
#       fetch_submodules = true
#     }
#   }

#   source_version = "master"
# }