import os
import logging
from pyspark.sql import SparkSession

# Configure logging with more detailed format
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)

def create_spark_session():
    spark_mode = os.getenv("SPARK_MODE", "local")
    
    builder = SparkSession.builder \
        .appName("DevContainerDemo") \
        .config("spark.ui.port", "4040") \
        .config("spark.sql.shuffle.partitions", "4") \
        .config("spark.executor.memory", "2g") \
        .config("spark.driver.memory", "1g")

    if spark_mode == "cluster":
        builder = builder.master("spark://spark-master:7077")
        logger.info("Running in cluster mode")
    else:
        builder = builder.master("local[*]")
        logger.info("Running in local mode")

    return builder.getOrCreate()

def run_spark_job():
    spark = None
    try:
        spark = create_spark_session()
        
        # Sample data processing
        data = [("Python", 1), ("Spark", 2), ("FastAPI", 3)]
        df = spark.createDataFrame(data, ["library", "rating"])
        
        logger.info("Original Data:")
        df.show()
        
        transformed_df = df.withColumn("rating_boost", df["rating"] * 10)
        
        logger.info("Transformed Data:")
        transformed_df.show()
        
        return transformed_df.collect()
        
    except Exception as e:
        logger.error(f"Error in Spark job: {str(e)}")
        raise
    finally:
        if spark:
            spark.stop()
            logger.info("Spark session stopped")

if __name__ == "__main__":
    logger.info("Starting Spark job...")
    results = run_spark_job()
    logger.info("Job results:")
    for row in results:
        logger.info(row)