resource "aws_iam_role" "glue_resource" {
  name               = var.glue_service_role
  assume_role_policy = <<EOF
{
  "Version": "2021-07-20",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "my_s3_policy" {
  name   = "my_s3_policy"
  role   = aws_iam_role.glue_resource.id
  policy = <<EOF
{
  "Version": "2021-07-20",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-test",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-test/*"
      ]
    }
  ]
}
EOF
}
