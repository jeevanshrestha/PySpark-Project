import os
import sys
from pyspark.sql import SparkSession

def log_environment():
    print("\n=== ENVIRONMENT ===")
    print(f"Python: {sys.executable}")
    print(f"Version: {sys.version}")
    print(f"PATH: {os.getenv('PATH')}")
    print(f"PYSPARK_PYTHON: {os.getenv('PYSPARK_PYTHON')}")
    print(f"PYSPARK_DRIVER_PYTHON: {os.getenv('PYSPARK_DRIVER_PYTHON')}\n")

def main():
    # log_environment()
    
    spark = (
        SparkSession.builder
        .appName("FixedSparkJob")
        .config("spark.sql.execution.pyspark.udf.faulthandler.enabled", "true")
        .config("spark.python.worker.faulthandler.enabled", "true")
        .config("spark.driver.memory", "2g")
        .config("spark.executor.memory", "2g")
        .config("spark.python.worker.reuse", "false")
        .getOrCreate()
    )

    try:
        # Simple test that doesn't require worker communication
        print("\nTesting SparkContext...")
        print(f"Spark version: {spark.version}")
        print(f"Spark UI: {spark.sparkContext.uiWebUrl}")
        
        # Test with simple local data
        data = [("Test", 1), ("Spark", 2)]
        df = spark.createDataFrame(data, ["text", "value"])
        df.show()
        
        print("\nSpark test completed successfully!")
        
    except Exception as e:
        print(f"\nERROR: {str(e)}", file=sys.stderr)
        raise
    finally:
        spark.stop()

if __name__ == "__main__":
    main()