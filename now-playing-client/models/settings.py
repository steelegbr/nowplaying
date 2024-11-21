from pydantic import BaseModel


class Settings(BaseModel):
    client_id: str = ""
    device_code: str = ""
    domain: str = ""
