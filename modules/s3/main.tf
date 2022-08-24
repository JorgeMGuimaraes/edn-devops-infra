resource "aws_s3_bucket" "edn_portfolio_app" {
  bucket = var.bucket_name
  tags = {
    Name = "edn_portfolio_app"
  }
}

resource "aws_s3_bucket_acl" "edn_portfolio_app_acl" {
  bucket = aws_s3_bucket.edn_portfolio_app.id
  acl    = "private"
}

locals {
  s3_origin_id = "edn_portfolio_app_origin"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "edn_portfolio_app_origin"
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled = true
  comment = "cloudfront-webapp"

  origin {
    domain_name = aws_s3_bucket.edn_portfolio_app.bucket_regional_domain_name
    #  origin_id   = local.s3_origin_id
    origin_id = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

data "aws_iam_policy_document" "cf_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.edn_portfolio_app.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}
resource "aws_s3_bucket_policy" "cf_s3_bucket_policy" {
  bucket = aws_s3_bucket.edn_portfolio_app.id
  policy = data.aws_iam_policy_document.cf_s3_policy.json
}
resource "aws_s3_bucket_public_access_block" "cf_s3_bucket_acl" {
  bucket              = aws_s3_bucket.edn_portfolio_app.id
  block_public_acls   = true
  block_public_policy = true
}