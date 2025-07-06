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
