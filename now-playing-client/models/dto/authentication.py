from pydantic import BaseModel, HttpUrl


class DeviceCodePayload(BaseModel):
    client_id: str
    scope: str


class DeviceCodeResponse(BaseModel):
    device_code: str
    expires_in: int
    interval: int
    user_code: str
    verification_uri_complete: HttpUrl
