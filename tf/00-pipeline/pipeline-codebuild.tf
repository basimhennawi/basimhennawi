module "codebuild_deploy_infrastructure" {
  source              = "../modules/codebuild"

  project_name        = "${var.app}-${var.service}-deploy-infrastructure"
  role_arn            = aws_iam_role.codebuild_role.arn
  buildspec           = "tf/00-pipeline/buildspecs/deploy-infrastructure.yaml"
  target_directory    = "tf/10-infrastructure"
  env                 = var.env
  vpc_id              = data.aws_vpc.pipeline.id
  subnet_ids          = data.aws_subnet_ids.pipeline_private.ids
  security_group_id   = aws_security_group.codebuild_pipeline.id

  default_tags        = local.default_tags
}

module "codebuild_deploy_project" {
  source              = "../modules/codebuild-project"

  project_name        = "${var.app}-${var.service}-deploy-project"
  role_arn            = aws_iam_role.codebuild_role.arn
  buildspec           = "tf/00-pipeline/buildspecs/deploy-project.yaml"
  # target_directory    = "tf/10-project"
  # env                 = var.env
  vpc_id              = data.aws_vpc.pipeline.id
  subnet_ids          = data.aws_subnet_ids.pipeline_private.ids
  security_group_id   = aws_security_group.codebuild_pipeline.id

  default_tags        = local.default_tags
}