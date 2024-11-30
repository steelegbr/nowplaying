from constants.headers import JSON_POST_HEADERS
from kivy.network.urlrequest import UrlRequest
from models.dto.nowplaying import NowPlayingDto, StationDto
from services.authentication import AuthenticationService, AuthenticationServiceState
from services.logging import get_logger, Logger
from services.settings import SettingsService
from typing import Optional
from urllib.parse import quote


class ApiService:
    __authentication_service: AuthenticationService
    __last_now_playing: NowPlayingDto
    __logger: Logger
    __settings_service: SettingsService

    instance = None
    LOG_PREFIX = "API Service"

    def __new__(
        cls,
        authentication_service: AuthenticationService = AuthenticationService(),
        logger: Logger = get_logger(__name__),
        settings_service: SettingsService = SettingsService(),
    ):
        if not cls.instance:
            cls.instance = super(ApiService, cls).__new__(cls)
            cls.instance.__authentication_service = authentication_service
            cls.instance.__logger = logger
            cls.instance.__settings_service = settings_service
        return cls.instance

    def __get_headers(self):
        if (
            self.__authentication_service.get_state()
            is not AuthenticationServiceState.Authenticated
        ):
            self.__logger.error(
                "%s: could not make request as authentication service is in %s state",
                self.LOG_PREFIX,
                self.__authentication_service.get_state(),
            )
            return

        return JSON_POST_HEADERS | {
            "Authorization": f"Bearer {self.__authentication_service.get_access_token()}"
        }

    def update_now_playing(self, now_playing: Optional[NowPlayingDto]):
        headers = self.__get_headers()
        if not headers:
            return

        settings = self.__settings_service.get()
        url = f"{settings.base_url}api/station/{quote(settings.station)}/nowplaying"
        self.__last_now_playing = now_playing

        self.__logger.info(
            "%s: updating now playing on URL %s with payload %s",
            self.LOG_PREFIX,
            url,
            now_playing,
        )
        UrlRequest(
            url,
            method="PUT",
            on_success=self.now_playing_success,
            on_failure=self.now_playing_failure,
            on_error=self.now_playing_error,
            req_body=(
                self.__last_now_playing.model_dump_json().encode("utf-8")
                if now_playing
                else None
            ),
            req_headers=headers,
        )

    def now_playing_success(self, request, result):
        self.__logger.info("%s: now playing update success", self.LOG_PREFIX)

    def now_playing_failure(self, request, result):
        self.__logger.error(
            "%s: now playing update failure with result %s", self.LOG_PREFIX, result
        )
        self.__register_station()

    def now_playing_error(self, request, error: str):
        self.__logger.error(
            "%s: now playing update error with reason %s", self.LOG_PREFIX, error
        )

    def __register_station(self):
        settings = self.__settings_service.get()
        url = f"{settings.base_url}api/station/"

        UrlRequest(
            url,
            method="PUT",
            on_success=self.register_station_success,
            on_failure=self.register_station_failure,
            on_error=self.register_station_error,
            req_body=StationDto(name=settings.station).model_dump_json(),
            req_headers=self.__get_headers(),
        )

    def register_station_success(self, request, result):
        self.__logger.info("%s: register station success", self.LOG_PREFIX)
        self.update_now_playing(self.__last_now_playing)

    def register_station_failure(self, request, result):
        self.__logger.error(
            "%s: register station failure with result %s", self.LOG_PREFIX, result
        )

    def register_station_error(self, request, error: str):
        self.__logger.error(
            "%s: register station error with reason %s", self.LOG_PREFIX, error
        )
