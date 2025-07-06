import os
from typing import Optional

class Settings:
    # FastAPI Secret Key - Change this in production!
    SECRET_KEY: str = os.getenv("SECRET_KEY", "kz4cXLJv_TCVxRsPN-FqUOwwN1-OIgiDUR8lmCLnKwc")
    
    # Algorithm for JWT tokens
    ALGORITHM: str = "HS256"
    
    # Access token expire minutes
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # Database settings
    DATABASE_URL: str = os.getenv("DATABASE_URL", "postgresql://user:password@localhost/dbname")
    
    # API settings
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "PySpark FastAPI App"
    
    # CORS settings
    BACKEND_CORS_ORIGINS: list = ["http://localhost:3000", "http://localhost:8080"]
    
    class Config:
        case_sensitive = True

settings = Settings() 