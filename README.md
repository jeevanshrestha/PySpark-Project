# Dev Container Project

Python Dev Container with:
- PySpark
- scikit-learn
- pandas
- numpy
- FastAPI
- PostgreSQL

## Installation

### 1. Python Environment Setup
```powershell
# Create virtual environment
py -3.10 -m venv .venv

# Activate environment
.\.venv\Scripts\activate

# Install dependencies
pip install pyspark==3.5.0 py4j==0.10.9.7



# Ensure Python is in PATH correctly
```powershell
# Add virtual environment's Scripts to PATH
$env:PATH = "$pwd\.venv\Scripts;" + $env:PATH

# Set PySpark environment variables before running scripts
$env:PYSPARK_PYTHON = "$pwd\.venv\Scripts\python.exe"
$env:PYSPARK_DRIVER_PYTHON = "$pwd\.venv\Scripts\python.exe"
$env:SPARK_LOCAL_IP = "127.0.0.1"
```


## Setup
1. Open in VS Code
2. Install "Dev Containers" extension
3. Reopen in container (Ctrl+Shift+P > "Reopen in Container")

## Running Services
- **FastAPI**: `uvicorn app.main:app --host 0.0.0.0 --port 8000`
- **Spark Job**: `python app/spark_job.py`
- **PostgreSQL**: Auto-started in container

## Access
- FastAPI: http://localhost:8000
- Spark UI: http://localhost:4040 (when Spark job is running)
- PostgreSQL: `postgresql://postgres:postgres@localhost:5432/appdb`
