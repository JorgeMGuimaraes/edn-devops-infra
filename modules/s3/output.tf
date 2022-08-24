output "s3_bucket_name" {
  value = aws_s3_bucket.edn_portfolio_app.id
}

output "cloudfront_dns" {
  value = aws_cloudfront_distribution.cf_distribution.domain_name
}