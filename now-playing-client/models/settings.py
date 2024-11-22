from pydantic import BaseModel


class Settings(BaseModel):
    client_id: str = ""
    domain: str = ""
    now_playing_file: str = ""
