resource "aws_iam_role" "glue_resource" {
  name               = var.glue_service_role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
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

resource "aws_iam_policy" "s3_policy" {
  name   = "bigdata_analysis_with_youtube_data_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-test",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-test/*",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-cleaned",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-cleaned/*",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-assets",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-assets/*",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-analytics",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-analytics/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::aws-glue-assets-011528285286-us-east-1/scripts/join.py"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_policy_resource_attachment" {
  role       = aws_iam_role.glue_resource.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy" "youtube_analysis_glue_cloudwatch_logs_policy" {
  name   = "youtube_analysis_glue_cloudwatch_logs_policy"
  role   = aws_iam_role.glue_resource.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "youtube_analysis_glue_s3_logs_and_glue_policy" {
  name   = "youtube_analysis_glue_s3_logs_and_glue_policy"
  role   = aws_iam_role.glue_resource.id
  policy = <<EOF
{
  "Version": "2012-10-17",
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
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:/aws-glue/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "glue:GetDatabase",
        "glue:GetTable",
        "glue:GetPartition",
        "glue:GetPartitions",
        "glue:CreateTable",
        "glue:UpdateTable",
        "glue:DeleteTable",
        "glue:BatchCreatePartition",
        "glue:BatchDeletePartition",
        "glue:BatchGetPartition"
      ],
      "Resource": [
        "arn:aws:glue:*:*:catalog",
        "arn:aws:glue:*:*:database/*",
        "arn:aws:glue:*:*:table/*/*"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_role" "youtube_analysis_etl_json_function" {
  name               = "youtube_analysis_etl_json_function"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM Policy for Lambda (S3 Read/Write)
resource "aws_iam_role_policy" "lambda_s3_policy" {
  name   = "lambda_s3_policy"
  role   = aws_iam_role.youtube_analysis_etl_json_function.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-test",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-test/*",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-cleaned",
        "arn:aws:s3:::bigdata-analysis-with-youtube-data-cleaned/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "glue:GetDatabase",
        "glue:GetTable",
        "glue:GetPartition",
        "glue:CreateTable",
        "glue:UpdateTable",
        "glue:DeleteTable",
        "glue:BatchCreatePartition",
        "glue:BatchDeletePartition",
        "glue:BatchGetPartition"
      ],
      "Resource": [
        "arn:aws:glue:*:*:catalog",
        "arn:aws:glue:*:*:database/*",
        "arn:aws:glue:*:*:table/*/*"
      ]
    }
  ]
}
EOF
}