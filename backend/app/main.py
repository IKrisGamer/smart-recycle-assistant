from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.database import Base, engine
import app.models # noqa: F401 (nạp model để create_all thấy các bảng)

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Smart Recycle Assistant")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health():
    return {"status": "ok"}

