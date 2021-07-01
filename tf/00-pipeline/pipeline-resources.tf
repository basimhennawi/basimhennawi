resource "aws_s3_bucket" "pipeline" {
  bucket = "${local.basename}-pipeline-${data.aws_caller_identity.current.account_id}-${var.region}"
  acl    = "private"
  tags   = merge(local.default_tags, {
    confidentiality = "C2"
  })

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = data.aws_kms_alias.s3_default.target_key_id
      }
    }
  }

  versioning {
    enabled = false
  }

  lifecycle_rule {
    enabled = true
    abort_incomplete_multipart_upload_days = 1
    expiration {
      days = 30
    }
    noncurrent_version_expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pipeline" {
  bucket                  = aws_s3_bucket.pipeline.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "pipeline" {
  bucket = aws_s3_bucket.pipeline.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "${local.basename}-pipeline-bucket-policy",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.pipeline.arn}",
        "${aws_s3_bucket.pipeline.arn}/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}