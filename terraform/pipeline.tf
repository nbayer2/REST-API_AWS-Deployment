resource "aws_codepipeline" "codepipeline" {
    name     = "cloudbootcamp-nicolas-bayer-pipeline"
    role_arn = "arn:aws:iam::324176193308:role/service-role/AWSCodePipelineServiceRole-eu-central-1-cloudbootcamp-nicolas-b"
    tags     = {}
    tags_all = {}

    artifact_store {
        location = "codepipeline-eu-central-1-886624031377" #"codepipeline-eu-central-1-520858806854"
        type     = "S3"
    }

    stage {
        name = "Source"

        action {
            category         = "Source"
            configuration    = {
                "BranchName"           = "master"
                "OutputArtifactFormat" = "CODE_ZIP"
                "PollForSourceChanges" = "false"
                "RepositoryName"       = "Cloudbootcamp-nicolas-bayer-Repository"
            }
            input_artifacts  = []
            name             = "Source"
            namespace        = "SourceVariables"
            output_artifacts = [
                "SourceArtifact",
            ]
            owner            = "AWS"
            provider         = "CodeCommit"
            region           = "eu-central-1"
            run_order        = 1
            version          = "1"
        }
    }
    stage {
        name = "Build"

        action {
            category         = "Build"
            configuration    = {
                "ProjectName" = "Cloudbootcamp-nicolas-bayer-build"
            }
            input_artifacts  = [
                "SourceArtifact",
            ]
            name             = "Build"
            namespace        = "BuildVariables"
            output_artifacts = [
                "BuildArtifact",
            ]
            owner            = "AWS"
            provider         = "CodeBuild"
            region           = "eu-central-1"
            run_order        = 1
            version          = "1"
        }
    }
}