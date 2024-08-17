CREATE EXTERNAL TABLE `raw_statistics_13c69d707ec5737ceb618a230497be05`(
  `video_id` string, 
  `trending_date` string, 
  `title` string, 
  `channel_title` string, 
  `category_id` bigint, 
  `publish_time` string, 
  `tags` string, 
  `views` bigint, 
  `likes` bigint, 
  `dislikes` bigint, 
  `comment_count` bigint, 
  `thumbnail_link` string, 
  `comments_disabled` boolean, 
  `ratings_disabled` boolean, 
  `video_error_or_removed` boolean, 
  `description` string)
PARTITIONED BY ( 
  `region` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://bigdata-analysis-with-youtube-data-cleaned/youtube/raw_statistics/'
TBLPROPERTIES (
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='youtube_analysis_glue-crawler_cleaned_partition', 
  'averageRecordSize'='223', 
  'classification'='parquet', 
  'compressionType'='none', 
  'objectCount'='3', 
  'partition_filtering.enabled'='true', 
  'recordCount'='7102', 
  'sizeKey'='923066', 
  'typeOfData'='file')