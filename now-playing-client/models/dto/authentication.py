from pydantic import BaseModel, HttpUrl


class DeviceCodePayload(BaseModel):
    client_id: str
    scope: str


class DeviceCodeResponse(BaseModel):
    verification_uri_complete: HttpUrl
    user_code: str
