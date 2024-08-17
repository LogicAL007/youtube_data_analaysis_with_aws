provider "aws" {
  profile = "default"
  region  = var.region_name
}
resource "aws_s3_bucket" "youtube-analysis-bucket" {
  bucket = var.bucket-name
  tags = {
    Name = "S3Bucket"
  }
}

#Resource to disable versioning
resource "aws_s3_bucket_versioning" "versioning_demo" {
  bucket = aws_s3_bucket.youtube-analysis-bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

#Block Public Access
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.youtube-analysis-bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_glue_catalog_database" "youtube-analysis-glue-data-catalog" {
  name = var.glue_catalog
}
resource "aws_glue_catalog_database" "youtube-analysis-glue-data-catalog_cleansed" {
  name = "youtube_analysis_glue_catalog_db_cleansed"
}
resource "aws_glue_catalog_database" "bigdata-youtube-statistics" {
  name = "bigdata_youtube_statistics"
}
resource "aws_s3_bucket" "youtube-analysis-bucket-cleaned" {
  bucket = var.bucket-cleaned
  tags = {
    Name      = "S3Bucket"
    Developer = "Omotosho Ayomide"
    Email     = "Ayomidemtsh@gmail.com"
  }
}

#Resource to disable versioning 
resource "aws_s3_bucket_versioning" "versioning_demo_cleaned" {
  bucket = aws_s3_bucket.youtube-analysis-bucket-cleaned.id
  versioning_configuration {
    status = "Disabled"
  }
}

#Block Public Access
resource "aws_s3_bucket_public_access_block" "public_block_cleaned" {
  bucket = aws_s3_bucket.youtube-analysis-bucket-cleaned.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lambda Function for Processing JSON and Writing to S3
resource "aws_lambda_function" "s3_event_lambda" {
  function_name = "s3_event_lambda"
  role          = aws_iam_role.youtube_analysis_etl_json_function.arn
  handler       = "lambda_function_json_par.lambda_handler"
  runtime       = "python3.8"
  timeout       = 60

  # Location of your Lambda deployment package
  filename         = "lambda_function_payload.zip" # Path to your deployment package
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      s3_cleansed_layer       = "s3://${aws_s3_bucket.youtube-analysis-bucket-cleaned.bucket}/youtube/cleansed_statistics/reference_data/"
      glue_catalog_db_name    = "youtube_analysis_glue_catalog_db_cleansed"
      glue_catalog_table_name = "cleansed_statistics_reference_data"
      write_data_operation    = "append"
    }
  }

  depends_on = [aws_iam_role_policy.lambda_s3_policy]
}

# S3 Bucket Notification (to trigger Lambda)
resource "aws_s3_bucket_notification" "source_bucket_notification" {
  bucket = aws_s3_bucket.youtube-analysis-bucket.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_event_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invocation]
}

# Lambda Permission to be Invoked by S3
resource "aws_lambda_permission" "allow_s3_invocation" {
  statement_id  = "AllowS3Invocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_event_lambda.function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.youtube-analysis-bucket.arn
}

# Package and Deploy Lambda Function Code
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda/lambda_function_json_par.py"
  output_path = "lambda_function_payload.zip"
}


resource "aws_s3_bucket" "youtube-analysis-bucket-analytics" {
  bucket = var.bucket-analytics
  tags = {
    Name = "S3Bucket"
  }
}

#Resource to disable versioning
resource "aws_s3_bucket_versioning" "versioning_demo_analytics" {
  bucket = aws_s3_bucket.youtube-analysis-bucket-analytics.id
  versioning_configuration {
    status = "Disabled"
  }
}

#Block Public Access
resource "aws_s3_bucket_public_access_block" "public_block_analytics" {
  bucket = aws_s3_bucket.youtube-analysis-bucket-analytics.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "youtube-analysis-bucket-asset" {
  bucket = var.bucket-assets
  tags = {
    Name = "S3Bucket"
  }
}

#Resource to disable versioning
resource "aws_s3_bucket_versioning" "versioning_demo_assets" {
  bucket = aws_s3_bucket.youtube-analysis-bucket-asset.id
  versioning_configuration {
    status = "Disabled"
  }
}

#Block Public Access
resource "aws_s3_bucket_public_access_block" "public_block_assets" {
  bucket = aws_s3_bucket.youtube-analysis-bucket-asset.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}