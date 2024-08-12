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
  name = "${var.glue_catalog}"
}

resource "aws_s3_bucket" "youtube-analysis-bucket-cleaned" {
  bucket = var.bucket-cleaned
  tags = {
    Name = "S3Bucket"
    Developer = "Omotosho Ayomide"
    Email = "Ayomidemtsh@gmail.com"
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
