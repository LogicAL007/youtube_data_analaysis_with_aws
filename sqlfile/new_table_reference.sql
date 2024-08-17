CREATE EXTERNAL TABLE `raw_statistics_reference_data`(
  `kind` string COMMENT 'from deserializer', 
  `etag` string COMMENT 'from deserializer', 
  `items` array<struct<kind:string,etag:string,id:string,snippet:struct<channelid:string,title:string,assignable:boolean>>> COMMENT 'from deserializer')
ROW FORMAT SERDE 
  'org.openx.data.jsonserde.JsonSerDe' 
WITH SERDEPROPERTIES ( 
  'paths'='etag,items,kind') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://bigdata-analysis-with-youtube-data-test/youtube/raw_statistics_reference_data/'
TBLPROPERTIES (
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='youtube_analysis_glue-crawler_raw', 
  'averageRecordSize'='8156', 
  'classification'='json', 
  'compressionType'='none', 
  'objectCount'='10', 
  'recordCount'='10', 
  'sizeKey'='81579', 
  'typeOfData'='file')