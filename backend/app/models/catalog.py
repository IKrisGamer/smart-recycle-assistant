from sqlalchemy import String, Text, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class WasteGruop(Base):
    __tablename__ = "waste_groups"
    
    code: Mapped[str] = mapped_column(String(20), primary_key=True)
    name: Mapped[str] = mapped_column(String(100))
    color: Mapped[str] = mapped_column(String(20))
    
    
class Material(Base):
    __tablename__ = "materials"
    
    code: Mapped[str] = mapped_column(String(30), primary_key=True)
    name: Mapped[str] = mapped_column(String(100))
    group_code: Mapped[str] = mapped_column(ForeignKey("waste_groups.code"))
    
    
class Guide(Base):
    __tablename__ = "guides"
    
    id: Mapped[int] = mapped_column(primary_key=True)
    material_code: Mapped[str] = mapped_column(ForeignKey("materials.code"))
    condition: Mapped[str] = mapped_column(String(30), default="any")
    steps: Mapped[str] = mapped_column(Text)
    warning: Mapped[str | None] = mapped_column(Text)
    is_safety: Mapped[bool] = mapped_column(default=False) 