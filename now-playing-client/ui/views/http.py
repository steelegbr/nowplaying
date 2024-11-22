from constants.settings import SAVE_DELAY
from kivy.clock import Clock
from kivy.uix.boxlayout import BoxLayout
from services.logging import get_logger, Logger
from services.settings import SettingsService
from pydantic import HttpUrl, ValidationError


class BaseUrlBlock(BoxLayout):
    __event = None
    __logger: Logger
    __settings_service: SettingsService

    LOG_PREFIX = "Base URL"

    def __init__(
        self,
        logger: Logger = get_logger(__name__),
        settings_service: SettingsService = SettingsService(),
        **kwargs,
    ):
        super().__init__(**kwargs)
        self.__logger = logger
        self.__settings_service = settings_service

    def on_kv_post(self, base_class):
        settings = self.__settings_service.get()
        self.ids.base_url.text = str(settings.base_url)

    def change_base_url(self, domain: str):
        self.__logger.debug("%s: Delayed save triggered", self.LOG_PREFIX)
        if self.__event:
            self.__logger.debug("%s: Removing existing trigger", self.LOG_PREFIX)
            self.__event.cancel()

        self.__logger.debug("%s: Scheduling delayed trigger", self.LOG_PREFIX)
        self.__event = Clock.schedule_once(self.delayed_save_callback, SAVE_DELAY)

    def delayed_save_callback(self, dt):
        try:
            settings = self.__settings_service.get()
            settings.base_url = HttpUrl(self.ids.base_url.text)
            self.__settings_service.save(settings)
        except ValidationError:
            self.__logger.warning(
                "%s: cannot convert %s to a URL, aborting save",
                self.LOG_PREFIX,
                self.ids.base_url.text,
            )
