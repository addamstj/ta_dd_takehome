data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "ct_logstorage" {
    bucket = "tf-assignment-ct-logstorage"
    force_destroy = true // NOTE: Enabled will delete even if not empty - remove if logs are required
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::tf-assignment-ct-logstorage"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::tf-assignment-ct-logstorage/cloudtrail/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
    logging {
       target_bucket = aws_s3_bucket.s3_logstorage.id
       target_prefix = "log/"
    }
}

resource "aws_s3_bucket" "s3_logstorage" {
    bucket = "tf-assignment-s3-logstorage"
    force_destroy = true // NOTE: Enabled will delete even if not empty - remove if logs are required
    acl = "log-delivery-write"
}