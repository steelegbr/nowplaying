from pydantic import BaseModel, Field
from typing import Optional


class NowPlayingDto(BaseModel):
    artist: str
    title: str
    year: Optional[int] = Field(None, ge=1900, lt=3000)
