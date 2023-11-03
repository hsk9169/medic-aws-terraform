resource "aws_s3_bucket" "feed_bucket" {
  bucket = "${var.name_prefix}-${var.service_name}-${var.env}-feed-images"

  dynamic "logging" {
    for_each = []
    content {
      target_bucket = aws_s3_bucket.log_bucket.id
      target_prefix = "s3-log/"
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-feed-bucket"
    }
  )
}

resource "aws_s3_bucket" "auth_bucket" {
  bucket = "${var.name_prefix}-${var.service_name}-${var.env}-auth-images"

  dynamic "logging" {
    for_each = []
    content {
      target_bucket = aws_s3_bucket.log_bucket.id
      target_prefix = "s3-log/"
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-auth-bucket"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "feed_protected_bucket" {
  bucket              = aws_s3_bucket.feed_bucket.id
  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_public_access_block" "auth_protected_bucket" {
  bucket              = aws_s3_bucket.auth_bucket.id
  block_public_acls   = false
  block_public_policy = false
}
