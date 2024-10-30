from pydantic import BaseModel

class AuthenticationSettings(BaseModel):
    domain: str
    client_id: str