variable "bucket-name" {
  default = "bigdata-analysis-with-youtube-data-test"
}
variable "bucket-cleaned" {
  default = "bigdata-analysis-with-youtube-data-cleaned"
}
variable "region_name" {
  default = "us-east-1"
}
variable "glue_service_role" {
  default = "youtube_analysis_glue_service_role"
}

variable "glue_catalog" {
  default = "youtube_analysis_glue_catalog_db"
}