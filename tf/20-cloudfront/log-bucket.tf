resource "aws_s3_bucket" "this" {
  bucket = "cloudfront-logs-${local.basename}-${data.aws_caller_identity.current.account_id}-${var.region}"
  versioning {
    enabled = true
  }

  // all unencrypted objects will be encrypted by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        // uses default s3 kms key with alias aws/s3
        sse_algorithm = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    enabled = true

    abort_incomplete_multipart_upload_days = 1
    expiration {
      expired_object_delete_marker = true
    }
    noncurrent_version_expiration {
      days = 365
    }

    noncurrent_version_transition {
      days = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags   = merge(local.default_tags, {
    confidentiality = "C2"
  })
}

// Avoid any public access by accidential misconfiguration
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
