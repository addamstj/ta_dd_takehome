
resource "aws_cloudtrail" "ct" {
    name = "tf-assignment-ct"
    s3_bucket_name = aws_s3_bucket.ct_logstorage.id
    s3_key_prefix = "cloudtrail"
    include_global_service_events = true
    is_multi_region_trail = true
    enable_log_file_validation = true
    kms_key_id = aws_kms_key.ctkey.arn
    cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cw_group.arn}:*"
    cloud_watch_logs_role_arn = "${aws_iam_role.ct_access.arn}"
    event_selector {
      read_write_type = "All"
      include_management_events  = true
    }
}