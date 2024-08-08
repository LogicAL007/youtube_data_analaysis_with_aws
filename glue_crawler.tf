resource "aws_glue_crawler" "example" {
  name          = "example-crawler"
  database_name = aws_glue_catalog_database.youtube-analysis-glue-data-catalog.name
  role          = aws_iam_role.glue_resource.arn
  targets {
    s3_targets {
      path = "s3://path-to-your-data/"
    }
  }
}
