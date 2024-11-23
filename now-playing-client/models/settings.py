from pydantic import BaseModel, HttpUrl


class Settings(BaseModel):
    base_url: HttpUrl = "https://example.org/"
    client_id: str = ""
    domain: str = ""
    now_playing_file: str = ""
    station: str = ""
