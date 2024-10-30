from models.authentication import AuthenticationSettings
from pydantic import BaseModel


class Settings(BaseModel):
    authentication: AuthenticationSettings
