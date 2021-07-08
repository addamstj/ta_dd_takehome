resource "aws_iam_role" "ct_access" {
    name = "ct_access"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF 
}

resource "aws_iam_policy" "ct_policy" {
  name = "ct_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:*",
            "Resource": "${aws_cloudwatch_log_group.cw_group.arn}:*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_cl_policy" {
  name = "attachment"
  roles = [aws_iam_role.ct_access.name]
  policy_arn = aws_iam_policy.ct_policy.arn
}