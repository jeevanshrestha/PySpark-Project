# Dev Container Project

Python Dev Container with:
- PySpark
- scikit-learn
- pandas
- numpy
- FastAPI
- PostgreSQL

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
