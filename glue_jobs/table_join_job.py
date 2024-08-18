import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node AWS Glue Data Catalog
AWSGlueDataCatalog_node1723849546603 = glueContext.create_dynamic_frame.from_catalog(database="youtube_analysis_glue_catalog_db", table_name="raw_statistics_13c69d707ec5737ceb618a230497be05", transformation_ctx="AWSGlueDataCatalog_node1723849546603")

# Script generated for node AWS Glue Data Catalog
AWSGlueDataCatalog_node1723849698900 = glueContext.create_dynamic_frame.from_catalog(database="youtube_analysis_glue_catalog_db_cleansed", table_name="cleansed_statistics_reference_data", transformation_ctx="AWSGlueDataCatalog_node1723849698900")

# Script generated for node Join
Join_node1723849736203 = Join.apply(frame1=AWSGlueDataCatalog_node1723849698900, frame2=AWSGlueDataCatalog_node1723849546603, keys1=["id"], keys2=["category_id"], transformation_ctx="Join_node1723849736203")

# Script generated for node Amazon S3
AmazonS3_node1723850626212 = glueContext.getSink(path="s3://bigdata-analysis-with-youtube-data-analytics/youtube/bigdata_youtube_statistics/", connection_type="s3", updateBehavior="UPDATE_IN_DATABASE", partitionKeys=["region", "id"], enableUpdateCatalog=True, transformation_ctx="AmazonS3_node1723850626212")
AmazonS3_node1723850626212.setCatalogInfo(catalogDatabase="bigdata_youtube_statistics",catalogTableName="bigdata_youtube_statistics")
AmazonS3_node1723850626212.setFormat("glueparquet", compression="snappy")
AmazonS3_node1723850626212.writeFrame(Join_node1723849736203)
job.commit()