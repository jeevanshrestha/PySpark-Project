<#
.SYNOPSIS
    Complete PySpark 3.5.0 + FastAPI setup with proper cleanup
#>

# 1. Clean existing environment
Remove-Item -Recurse -Force .venv -ErrorAction SilentlyContinue
pip cache purge

# 2. Create Python 3.11 environment (recommended for PySpark 3.5.0)
py -3.11 -m venv .venv
.\.venv\Scripts\activate

# 3. Install base packages
python -m pip install --upgrade pip setuptools wheel

# 4. Install packages with verified versions
@(
    "numpy<2.0.0"
    "pandas==2.2.3"
    "matplotlib==3.8.4"
    "psycopg2-binary==2.9.9"
    "SQLAlchemy==2.0.29"
    "fastapi==0.111.0"
    "uvicorn==0.29.0"
    "pydantic==2.7.1"
    "pyspark==3.5.0"
    "py4j==0.10.9.7"
    "pyarrow==14.0.0"
) | ForEach-Object {
    pip install $_
}

# 5. Configure Spark to handle temp files better
$env:SPARK_LOCAL_DIRS = "$pwd\spark_temp"
New-Item -ItemType Directory -Path $env:SPARK_LOCAL_DIRS -Force

# 6. Test installation
python -c "
from pyspark.sql import SparkSession
import tempfile

# Configure Spark to use local temp dir
spark = SparkSession.builder \
    .config('spark.local.dir', '$env:SPARK_LOCAL_DIRS') \
    .config('spark.cleaner.referenceTracking.cleanCheckpoints', 'true') \
    .getOrCreate()

try:
    df = spark.createDataFrame([('Test', 1), ('Spark', 2)], ['text', 'value'])
    df.show()
    print('\nSpark test successful!')
finally:
    spark.stop()
    # Clean up temp files
    Remove-Item -Recurse -Force $env:SPARK_LOCAL_DIRS -ErrorAction SilentlyContinue
"

Write-Host "`nSetup completed successfully!" -ForegroundColor Green