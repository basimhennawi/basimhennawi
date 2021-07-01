module "codebuild_deploy" {
  source              = "../modules/codebuild"

  project_name        = "${var.app}-${var.service}-deploy"
  role_arn            = aws_iam_role.codebuild_role.arn
  buildspec           = "00-pipeline/buildspecs/deploy.yaml"
  target_directory    = "10-infrastructure"
  env                 = var.env
  vpc_id              = data.aws_vpc.pipeline.id
  subnet_ids          = data.aws_subnet_ids.pipeline_private.ids
  security_group_id   = aws_security_group.codebuild_pipeline.id

  default_tags        = local.default_tags
}