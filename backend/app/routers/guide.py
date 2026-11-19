"""Router F2 (/guide) của C - bảng tri thức hướng dẫn xử lý rác.

Bảng tri thức: backend/app/data/f2_knowledge.json (khóa lớp trùng với ai/models/labels.json).
predict.py của A gọi get_guide(label) để gắn group và guide vào kết quả /predict.
"""
import json
from functools import lru_cache
from pathlib import Path

from fastapi import APIRouter, HTTPException

router = APIRouter(prefix="/guide", tags=["F2 - Hướng dẫn xử lý"])

# backend/app/routers/guide.py -> parents[1] là backend/app
KNOWLEDGE_PATH = Path(__file__).resolve().parents[1] / "data" / "f2_knowledge.json"


@lru_cache(maxsize=1)
def load_knowledge() -> dict:
    """Đọc bảng tri thức một lần rồi giữ trong bộ nhớ."""
    return json.loads(KNOWLEDGE_PATH.read_text(encoding="utf-8"))


def get_guide(label: str):
    """Trả về (group, guide) cho một nhãn; (None, None) nếu nhãn chưa có trong bảng."""
    data = load_knowledge()
    item = data["labels"].get(label)
    if item is None:
        return None, None
    group = {"id": item["group"], **data["groups"][item["group"]]}
    guide = {"name": item["name"], "warning": item["warning"], **item["guide"]}
    return group, guide


@router.get("")
def list_guides():
    """Toàn bộ bảng tri thức: groups và labels."""
    return load_knowledge()


@router.get("/{label}")
def read_guide(label: str):
    """Hướng dẫn cho một loại rác, ví dụ GET /guide/nhua"""
    group, guide = get_guide(label)
    if guide is None:
        raise HTTPException(status_code=404, detail=f"Chưa có hướng dẫn cho nhãn '{label}'")
    return {"label": label, "group": group, "guide": guide}
