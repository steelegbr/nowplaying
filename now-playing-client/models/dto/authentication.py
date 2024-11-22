from enum import StrEnum
from pydantic import BaseModel, HttpUrl


class Scope(StrEnum):
    OpenIdProfile = "openid profile"


class DeviceCodePayload(BaseModel):
    client_id: str
    scope: Scope


class DeviceCodeResponse(BaseModel):
    device_code: str
    expires_in: int
    interval: int
    user_code: str
    verification_uri_complete: HttpUrl


class GrantType(StrEnum):
    DeviceCode = "urn:ietf:params:oauth:grant-type:device_code"


class TokenPayload(BaseModel):
    grant_type: GrantType
    device_code: str
    client_id: str


class TokenResponseError(StrEnum):
    AuthorizationPending = "authorization_pending"
    SlowDown = "slow_down"
    ExpiredToken = "expired_token"
    AccessDenied = "access_denied"


class TokenErrorResponse(BaseModel):
    error: TokenResponseError
    error_description: str


class TokenResponse(BaseModel):
    access_token: str
    id_token: str
    token_type: str
    expires_in: int
