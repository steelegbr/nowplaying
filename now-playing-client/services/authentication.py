from constants.headers import JSON_POST_HEADERS
from enum import StrEnum
from kivy.network.urlrequest import UrlRequest
from models.dto.authentication import DeviceCodePayload, DeviceCodeResponse
from services.settings import SettingsService
from services.logging import get_logger, Logger
from typing import Callable, List
from webbrowser import open_new


class AuthenticationServiceState(StrEnum):
    Unauthenticated = "UNAUTHENTICATED"
    Error = "ERROR"
    DeviceCode = "DEVICE_CODE"
    AwaitingUserAuth = "AWAIT_USER_AUTH"
    TimedOut = "TIMED_OUT"
    Authenticated = "AUTHENTICATED"


class AuthenticationService:
    __callbacks = List[Callable[[AuthenticationServiceState], None]]
    __logger: Logger
    __settings_service: SettingsService
    __state: AuthenticationServiceState = AuthenticationServiceState.Unauthenticated

    instance = None
    LOG_PREFIX = "Authentication Service"
    SCOPE_OPENID = "openid profile"

    def __new__(
        cls,
        logger: Logger = get_logger(__name__),
        settings_service: SettingsService = SettingsService(),
    ):
        if not cls.instance:
            cls.instance = super(AuthenticationService, cls).__new__(cls)
            cls.instance.__callbacks = []
            cls.instance.__logger = logger
            cls.instance.__settings_service = settings_service
        return cls.instance

    def get_state(self) -> AuthenticationServiceState:
        return self.__state

    def __get_device_code(self) -> DeviceCodeResponse:
        settings = self.__settings_service.get()
        payload = DeviceCodePayload(
            client_id=settings.client_id, scope=self.SCOPE_OPENID
        )

        UrlRequest(
            f"https://{settings.domain}/oauth/device/code",
            on_success=self.handle_device_code_success,
            on_failure=self.handle_device_code_failure,
            on_error=self.handle_device_code_error,
            req_body=payload.model_dump_json(),
            req_headers=JSON_POST_HEADERS,
        )

    def __set_state(self, state: AuthenticationServiceState):
        self.__state = state
        for callback in self.__callbacks:
            callback(self.__state)

    def handle_device_code_success(self, request, result):
        self.__logger.info(f"{self.LOG_PREFIX}: successful device code request")
        device_code_response = DeviceCodeResponse.model_validate(result)
        self.__launch_browser(device_code_response)

    def handle_device_code_failure(self, request, result):
        self.__logger.error(
            f"{self.LOG_PREFIX}: failed device code request with result %s", result
        )
        self.__set_state(AuthenticationServiceState.Error)

    def handle_device_code_error(self, request, error: str):
        self.__logger.error(
            f"{self.LOG_PREFIX}: failed device code request with reason %s", error
        )
        self.__set_state(AuthenticationServiceState.Error)

    def __launch_browser(self, device_code_response: DeviceCodeResponse):
        self.__logger.info(
            f"{self.LOG_PREFIX}: Launching browser to {device_code_response.verification_uri_complete}"
        )
        open_new(str(device_code_response.verification_uri_complete))

    def authenticate(self):
        if self.get_state() in [
            AuthenticationServiceState.Error,
            AuthenticationServiceState.Unauthenticated,
        ]:
            self.__set_state(AuthenticationServiceState.DeviceCode)
            self.__get_device_code()
        else:
            self.__logger.warning(
                f"{self.LOG_PREFIX}: cannot start authentication attempt while in %s state",
                self.get_state(),
            )

    def deregister_callback(
        self, callback: Callable[[AuthenticationServiceState], None]
    ):
        if callback in self.__callbacks:
            self.__callbacks.remove(callback)
        self.__logger.info(f"{self.LOG_PREFIX}: deregister callback %s", callback)

    def register_callback(self, callback: Callable[[AuthenticationServiceState], None]):
        self.__callbacks.append(callback)
        self.__logger.info(f"{self.LOG_PREFIX}: register callback %s", callback)
        callback(self.__state)
