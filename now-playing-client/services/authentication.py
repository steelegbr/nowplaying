from enum import StrEnum
from requests import HTTPError, post
from models.dto.authentication import DeviceCodePayload, DeviceCodeResponse
from services.settings import SettingsService
from services.logging import get_logger, Logger
from typing import Callable, List
from webbrowser import open_new


class AuthenticationServiceState(StrEnum):
    Unauthenticated = "UNAUTHENTICATED"
    Error = "ERROR"
    DeviceCode = "DEVICE_CODE"


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

        response = post(
            f"https://{settings.domain}/oauth/device/code", data=payload.model_dump()
        )
        response.raise_for_status()
        return DeviceCodeResponse.model_validate(response.json())

    def __set_state(self, state: AuthenticationServiceState):
        self.__state = state
        for callback in self.__callbacks:
            callback(self.__state)

    def __save_device_code(self, device_code_response: DeviceCodeResponse):
        settings = self.__settings_service.get()
        settings.device_code = device_code_response.user_code
        self.__settings_service.save(settings)

    def __launch_browser(self, device_code_response: DeviceCodeResponse):
        self.__logger.info(
            f"{self.LOG_PREFIX}: Launching browser to {device_code_response.verification_uri_complete}"
        )
        open_new(str(device_code_response.verification_uri_complete))

    def authenticate(self):

        # TODO: Attempt authentication with existing device code

        # Get a new device code

        try:
            self.__set_state(AuthenticationServiceState.DeviceCode)
            device_code_response = self.__get_device_code()
            self.__save_device_code(device_code_response)
            self.__launch_browser(device_code_response)
        except HTTPError as ex:
            self.__logger.error(
                f"{self.LOG_PREFIX}: failed authentication request with reason %s and response %s",
                ex,
                ex.response.json(),
            )
            self.__set_state(AuthenticationServiceState.Error)

        # TODO: Trigger the wait for valid authentication into a thread to not lock up the UI

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
