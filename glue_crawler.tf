resource "aws_glue_crawler" "youtube-analysis-glue-crawler-resource" {
  database_name = aws_glue_catalog_database.youtube-analysis-glue-data-catalog.name
  name          = "youtube_analysis_glue-crawler_raw"
  role          = aws_iam_role.glue_resource.arn

  s3_target {
    path = "s3://${var.bucket-name}"
  }
}

# resource "aws_glue_trigger" "example" {
#   name = "example"
#   type = "ON_DEMAND"

#   actions {
#     job_name = aws_glue_job.example.name
#   }
# }