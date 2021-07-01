resource "aws_codepipeline" "this" {
  name = local.basename
  role_arn = aws_iam_role.codepipeline_role.arn
  tags = local.default_tags

  artifact_store {
    location = aws_s3_bucket.pipeline.bucket
    type = "S3"

    encryption_key {
      id = data.aws_kms_alias.s3_default.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      # Grant Access manually via Console
      configuration = {
        ConnectionArn        = data.aws_ssm_parameter.codestar_arn.value
        # FullRepositoryId     = "appinioGmbH/admin-interface" // TODO: after kai connect github to appinioGmbH
        FullRepositoryId     = "basimhennawi/basimhennawi"
        BranchName           = var.branch[var.env]
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Infrastructure"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
        "source_output"]
      version = "1"
      run_order = 1

      configuration = {
        ProjectName = module.codebuild_deploy_infrastructure.name
      }
    }

    action {
      name = "Project"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
        "source_output"]
      version = "1"
      run_order = 2

      configuration = {
        ProjectName = module.codebuild_deploy_project.name
      }
    }
  }
}
