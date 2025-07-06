#!/bin/bash

# Create project structure
mkdir -p devcontainer-project/{.devcontainer,app}

# Create .devcontainer files
cat > devcontainer-project/.devcontainer/devcontainer.json << 'EOL'
{
  "name": "Python Data Science & FastAPI",
  "dockerComposeFile": "docker-compose.yml",
  "service": "app",
  "workspaceFolder": "/workspace",
  "forwardPorts": [8000, 5432, 4040],
  "extensions": [
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-azuretools.vscode-docker"
  ],
  "settings": {
    "python.pythonPath": "/usr/local/bin/python",
    "python.linting.enabled": true
  }
}
EOL

cat > devcontainer-project/.devcontainer/docker-compose.yml << 'EOL'
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ..:/workspace
    ports:
      - "8000:8000"
      - "4040:4040"
      - "5432:5432"
    depends_on:
      db:
        condition: service_healthy
    environment:
      - POSTGRES_HOST=db
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=appdb
      - SPARK_MODE=local

  db:
    image: postgres:13-alpine
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: appdb
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  postgres-data:
EOL

cat > devcontainer-project/.devcontainer/Dockerfile << 'EOL'
FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-11-jre-headless \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PYSPARK_PYTHON=/usr/local/bin/python
ENV PYSPARK_DRIVER_PYTHON=/usr/local/bin/python

COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN apt-get purge -y --auto-remove gcc

WORKDIR /workspace
EOL

cat > devcontainer-project/.devcontainer/requirements.txt << 'EOL'
pyspark==3.4.0
scikit-learn==1.2.2
pandas==2.0.3
numpy==1.24.3
pydantic==1.10.9
fastapi==0.97.0
uvicorn==0.22.0
sqlalchemy==2.0.16
psycopg2-binary==2.9.6
jupyterlab==3.6.3
matplotlib==3.7.1
EOL

# Create app files
cat > devcontainer-project/app/main.py << 'EOL'
from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from . import database

app = FastAPI()

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def read_root():
    return {"message": "Hello from FastAPI in Dev Container!"}

@app.get("/data")
def sample_data():
    import pandas as pd
    import numpy as np
    df = pd.DataFrame({
        'values': np.random.rand(10),
        'category': ['A', 'B'] * 5
    })
    return df.to_dict()

@app.get("/db-test")
def db_test(db: Session = Depends(get_db)):
    result = db.execute("SELECT version();")
    version = result.fetchone()[0]
    return {"postgres_version": version}
EOL

cat > devcontainer-project/app/spark_job.py << 'EOL'
from pyspark.sql import SparkSession

def run_spark_job():
    spark = SparkSession.builder \\
        .appName("DevContainerDemo") \\
        .config("spark.ui.port", "4040") \\
        .getOrCreate()

    data = [("Python", 1), ("Spark", 2), ("FastAPI", 3)]
    columns = ["library", "rating"]
    df = spark.createDataFrame(data, columns)
    
    df.show()
    
    transformed_df = df.withColumn("rating_boost", df["rating"] * 10)
    results = transformed_df.collect()
    
    spark.stop()
    return results

if __name__ == "__main__":
    print("Running Spark job...")
    results = run_spark_job()
    for row in results:
        print(row)
EOL

cat > devcontainer-project/app/database.py << 'EOL'
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql://postgres:postgres@db/appdb"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def init_db():
    Base.metadata.create_all(bind=engine)
EOL

cat > devcontainer-project/app/models.py << 'EOL'
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String
from .database import Base

class ItemCreate(BaseModel):
    name: str
    description: str = None

class DBItem(Base):
    __tablename__ = "items"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    description = Column(String, index=True)
EOL

# Create root files
cat > devcontainer-project/.gitignore << 'EOL'
.env
.venv
__pycache__/
*.pyc
*.pyo
*.pyd
.DS_Store
.vscode/
data/
postgres-data/
EOL

cat > devcontainer-project/README.md << 'EOL'
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
EOL

echo "Project created in devcontainer-project directory"
echo "To zip the project:"
echo "  zip -r devcontainer-project.zip devcontainer-project"