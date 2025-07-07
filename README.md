# PySpark, FastAPI & PostgreSQL Development Environment

A robust local development setup for data engineering and API projects using PySpark 3.5.0, FastAPI, and PostgreSQL.

## Features

- PySpark 3.5.0
- FastAPI 0.111.0
- PostgreSQL (containerized)
- scikit-learn, pandas, numpy, matplotlib, pyarrow
- SQLAlchemy, psycopg2-binary
- Dev Containers support for VS Code

---

## 1. Clean & Prepare Python Environment

Open PowerShell and run:

```powershell
# Remove previous environment and pip cache
Remove-Item -Recurse -Force .venv -ErrorAction SilentlyContinue
pip cache purge

# Create Python 3.11 virtual environment (recommended for PySpark 3.5.0)
py -3.11 -m venv .venv
.\.venv\Scripts\activate

# Upgrade pip and essential build tools
python -m pip install --upgrade pip setuptools wheel

# Install dependencies with pinned versions
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
```

---

## 2. Download winutils.exe for Windows (Required for PySpark)

1. Download `winutils.exe` from a trusted [GitHub repository](https://github.com/steveloughran/winutils) (choose the version matching your Hadoop version, e.g., hadoop-3.0.0).
2. Create the directory `C:\Hadoop\bin` if it does not exist.
3. Place `winutils.exe` inside `C:\Hadoop\bin`.
4. Set the `HADOOP_HOME` environment variable to `C:\Hadoop`:
    - Open System Properties → Environment Variables.
    - Add a new user or system variable:  
      - **Variable name:** `HADOOP_HOME`  
      - **Variable value:** `C:\Hadoop`
    - Add `C:\Hadoop\bin` to your `Path` variable if not already present.
5. Restart your terminal or IDE to apply changes.

---

## 3. Configure Spark Temporary Directory

```powershell
# Set Spark temp directory for local development
$env:SPARK_LOCAL_DIRS = "$pwd\spark_temp"
New-Item -ItemType Directory -Path $env:SPARK_LOCAL_DIRS -Force
```

---

## 4. Test PySpark Installation

```powershell
python -c "
from pyspark.sql import SparkSession
import tempfile

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
"
```

---

## 5. Development Environment Setup

1. **Open in VS Code**
2. Install the **Dev Containers** extension.
3. Reopen in container: <kbd>Ctrl+Shift+P</kbd> → "Reopen in Container".

---

## 6. Running Services

- **FastAPI**:  
  ```bash
  uvicorn app.main:app --host 0.0.0.0 --port 8000
  ```
- **Spark Job**:  
  ```bash
  python app/spark_job.py
  ```
- **PostgreSQL**:  
  Auto-started in the dev container.

---

## 7. Access

- FastAPI: [http://localhost:8000](http://localhost:8000)
- Spark UI: [http://localhost:4040](http://localhost:4040) (when Spark job is running)
- PostgreSQL:  
  `postgresql://postgres:postgres@localhost:5432/appdb`

---

## Notes

- Ensure Python 3.11 is installed and available as `py -3.11`.
- Always activate the virtual environment before running scripts.
- Clean up Spark temp files as needed:  
  ```powershell
  Remove-Item -Recurse -Force $env:SPARK_LOCAL_DIRS -ErrorAction SilentlyContinue
  ```
- On Windows, `winutils.exe` and `HADOOP_HOME` are required for PySpark to work correctly.

---

**Setup completed successfully!**
