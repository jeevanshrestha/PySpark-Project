from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from app import database
from  app.config  import settings

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json"
)

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
    result = db.execute("SELECT version();") # type: ignore
    version = result.fetchone()[0]
    return {"postgres_version": version}
