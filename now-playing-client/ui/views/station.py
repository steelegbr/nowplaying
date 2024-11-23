from constants.settings import SAVE_DELAY
from kivy.clock import Clock
from kivy.uix.boxlayout import BoxLayout
from services.logging import get_logger, Logger
from services.settings import SettingsService


class StationBlock(BoxLayout):
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
        self.ids.station.text = settings.station

    def change_station(self, station: str):
        self.__logger.debug("%s: Delayed save triggered", self.LOG_PREFIX)
        if self.__event:
            self.__logger.debug("%s: Removing existing trigger", self.LOG_PREFIX)
            self.__event.cancel()

        self.__logger.debug("%s: Scheduling delayed trigger", self.LOG_PREFIX)
        self.__event = Clock.schedule_once(self.delayed_save_callback, SAVE_DELAY)

    def delayed_save_callback(self, dt):
        settings = self.__settings_service.get()
        settings.station = self.ids.station.text
        self.__settings_service.save(settings)
