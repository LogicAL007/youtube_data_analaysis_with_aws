resource "aws_glue_crawler" "youtube-analysis-glue-crawler-resource" {
  database_name = aws_glue_catalog_database.youtube-analysis-glue-data-catalog.name
  name          = "youtube_analysis_glue-crawler_raw"
  role          = aws_iam_role.glue_resource.arn
  description = "This is a crawler for youtube data analysis"

  s3_target {
    path = "s3://${var.bucket-name}/youtube/raw_statistics_reference_data/"
  }
} 

resource "aws_glue_crawler" "youtube-analysis-glue-crawler-resource-partition" {
  database_name = aws_glue_catalog_database.youtube-analysis-glue-data-catalog.name
  name          = "youtube_analysis_glue-crawler_raw_partition"
  role          = aws_iam_role.glue_resource.arn
  description = "This is a crawler for the region partitions of the youtube data analysis"

  s3_target {
    path = "s3://${var.bucket-name}/youtube/raw_statistics/"
  }
}

resource "aws_glue_crawler" "youtube-analysis-glue-crawler-resource-partition_parquet" {
  database_name = aws_glue_catalog_database.youtube-analysis-glue-data-catalog.name
  name          = "youtube_analysis_glue-crawler_cleaned_partition"
  role          = aws_iam_role.glue_resource.arn
  description = "This is a crawler for the region partitions of the youtube data analysis only for gu,ca and us"

  s3_target {
    path = "s3://${var.bucket-cleaned}/youtube/raw_statistics/"
  }
}

resource "aws_glue_job" "bigdata-youtube-glue-job" {
  name     = "bigdata_analaysis_csv_to_parquet"
  role_arn = aws_iam_role.glue_resource.arn

  command {
    script_location = "s3://${var.bucket-assets}/aws_resources/aws_glue/etl_jobs/glue_job_with_pushdown.py"
  }
}

resource "aws_glue_job" "join-tables" {
  name     = "join_tables"
  role_arn = aws_iam_role.glue_resource.arn

  command {
    script_location = "s3://${var.bucket-assets}/aws_resources/aws_glue/etl_jobs/table_join_job.py"
  }
}

resource "aws_glue_workflow" "youtube_analysis_workflow" {
  name        = "youtube_analysis_workflow"
  description = "Workflow for YouTube data analysis"
}

resource "aws_glue_trigger" "bigdata-youtube-csv-to-parquet" {
  name          = "bigdata_youtube_csv_to_parquet"
  workflow_name = aws_glue_workflow.youtube_analysis_workflow.name
  type          = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.bigdata-youtube-glue-job.name
  }
}

resource "aws_glue_trigger" "bigdata-youtube-join-tables" {
  name          = "bigdata_youtube_join_tables"
  workflow_name = aws_glue_workflow.youtube_analysis_workflow.name
  type          = "CONDITIONAL"
  predicate {
    conditions {
      logical_operator = "EQUALS"
      job_name         = aws_glue_job.bigdata-youtube-glue-job.name
      state            = "SUCCEEDED"
    }
  }

  actions {
    job_name = aws_glue_job.join-tables.name
  }
}
