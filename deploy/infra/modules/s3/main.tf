data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket = "${var.app_name}-access-logs-${var.environment}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.elb_logs.id
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${data.aws_elb_service_account.main.arn}"]
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.app_name}-access-logs-${var.environment}/*"
    },
    {
      "Action": ["s3:PutObject"],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.app_name}-access-logs-${var.environment}/*",
	    "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      },
      "Principal": {
	      "Service": "delivery.logs.amazonaws.com"
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${var.app_name}-access-logs-${var.environment}"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.elb_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
  bucket = aws_s3_bucket.elb_logs.id
  acl    = "private"
}