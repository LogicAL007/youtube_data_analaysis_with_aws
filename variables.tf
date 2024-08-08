variable "bucket-name" {
  default = "bigdata-analysis-with-youtube-data-test"
}

variable "region_name" {
  default = "us-east-1"
}
variable "glue_service_role" {
  default = "youtube_analysis_glue_service_role"
}

variable "glue_catalog" {
  default = "Youtube_analysis_glue_catalog_db"
}