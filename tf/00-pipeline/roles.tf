resource "aws_iam_role" "codepipeline_role" {
  name = "${local.basename}-codepipeline"
  tags = local.default_tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${local.basename}-codepipeline"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:Get*",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.pipeline.arn}",
        "${aws_s3_bucket.pipeline.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey"
      ],
      "Resource": [
        "${data.aws_kms_alias.s3_default.target_key_arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codestar-connections:UseConnection"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role" "codebuild_role" {
  name = "${local.basename}-codebuild"
  tags = local.default_tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${local.basename}-codebuild"
  role = aws_iam_role.codebuild_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.basename}-deployer"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:Get*",
        "s3:List*",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.pipeline.arn}",
        "${aws_s3_bucket.pipeline.arn}/*"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": [
        "${data.aws_ssm_parameter.codestar_arn.value}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey"
      ],
      "Resource": [
        "${data.aws_kms_alias.s3_default.target_key_arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:CreateNetworkInterfacePermission",
        "ec2:DescribeVpcs",
        "ec2:DescribeDhcpOptions"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter"
      ],
      "Resource": [
        "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${local.basename}-*"
      ]
    }
  ]
}
EOF
}
