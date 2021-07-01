data "aws_kms_alias" "s3_default_key" {
  name = "alias/aws/s3"
}

data "aws_kms_key" "s3_default_key" {
  key_id = data.aws_kms_alias.s3_default_key.target_key_id
}

resource "aws_iam_role" "deployer" {
  name = "${local.basename}-deployer"
  tags = local.default_tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.basename}-codebuild"
      }
    },
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Condition": {
        "StringLike": {
          "aws:PrincipalArn": [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*admin*",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*developer*",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*Administrator*"
          ]
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "deployer" {
  name = "${local.basename}-deployer"
  role = aws_iam_role.deployer.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid":"S3TerraformStateLock",
      "Effect":"Allow",
      "Action": [
        "s3:Get*",
        "s3:List*",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::terraform-state-${data.aws_caller_identity.current.account_id}-${var.region}",
        "arn:aws:s3:::terraform-state-${data.aws_caller_identity.current.account_id}-${var.region}/*"
      ]
    },
    {
      "Sid":"KMSTerraformStateLock",
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey"
      ],
      "Resource": [
        "${data.aws_kms_key.s3_default_key.arn}"
      ]
    },
    {
      "Sid":"DynamoTerraformStateLock",
      "Effect":"Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/terraform-state-lock"
    },
    {
      "Effect":"Allow",
      "Action": [
        "iam:AttachRolePolicy",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PassRole",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:ListAttachedRolePolicies",
        "iam:ListInstanceProfilesForRole",
        "iam:PutRolePolicy",
        "iam:CreateServiceLinkedRole",
        "iam:ListRolePolicies"
      ],
      "Resource": [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.app}-${var.env}-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
          "iam:CreateServiceLinkedRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy"
      ],
      "Resource": [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/*"
      ]
    },
    {
      "Sid": "CloudWatchAlarming",
      "Effect":"Allow",
      "Action": [
        "cloudwatch:*"
      ],
      "Resource": ["*"]
    },
    {
      "Sid": "GetAccountWideAlarmingTopic",
      "Effect":"Allow",
      "Action": [
        "sns:List*",
        "sns:Get*"
      ],
      "Resource": ["*"]
    },
    {
      "Sid": "ALBCertificate",
      "Effect":"Allow",
      "Action": [
        "acm:DescribeCertificate",
        "acm:ListTagsForCertificate",
        "acm:AddTagsToCertificate",
        "acm:DeleteCertificate"
      ],
      "Resource": ["arn:aws:acm:${var.region}:${data.aws_caller_identity.current.account_id}:certificate/*"]
    },
    {
      "Sid": "S3Application",
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${local.basename}-${data.aws_caller_identity.current.account_id}-${var.region}",
        "arn:aws:s3:::${local.basename}-${data.aws_caller_identity.current.account_id}-${var.region}/*"
      ]
    },
    {
      "Sid": "CloudfrontApplication",
      "Effect":"Allow",
      "Action": [
        "cloudfront:*"
      ],
      "Resource": ["*"]
    }
  ]
}
EOF
}
