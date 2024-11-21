from kivy.clock import Clock
from kivy.uix.boxlayout import BoxLayout
from services.logging import get_logger, Logger
from services.settings import SettingsService


class AuthUpdater:
    __client_id_block: None
    __domain_block: None
    __event: None
    __settings_service: SettingsService

    instance: None
    LOG_PREFIX = "Authentication Updater"
    SAVE_DELAY = 3

    def __new__(
        cls,
        logger: Logger = get_logger(__name__),
        settings_service: SettingsService = SettingsService(),
    ):
        if not hasattr(cls, "instance"):
            cls.instance = super(AuthUpdater, cls).__new__(cls)
            cls.instance.__client_id_block = None
            cls.instance.__domain_block = None
            cls.instance.__event = None
            cls.instance.__logger = logger
            cls.instance.__settings_service = settings_service
        return cls.instance

    def delayed_save_callback(self, dt):
        settings = self.__settings_service.get()
        settings.client_id = self.__client_id_block.ids.client_id.text
        settings.domain = self.__domain_block.ids.domain.text
        self.__settings_service.save(settings)

    def trigger_delayed_save(self):
        self.__logger.debug(f"{self.LOG_PREFIX}: Delayed save triggered")
        if self.__event:
            self.__logger.debug(f"{self.LOG_PREFIX}: Removing existing trigger")
            self.__event.cancel()

        self.__logger.debug(f"{self.LOG_PREFIX}: Scheduling delayed trigger")
        self.__event = Clock.schedule_once(self.delayed_save_callback, self.SAVE_DELAY)

    def register_client_id_block(self, client_id_block):
        self.__logger.info(f"{self.LOG_PREFIX}: Client ID block %s", client_id_block)
        self.__client_id_block = client_id_block

    def register_domain_block(self, domain_block):
        self.__logger.info(f"{self.LOG_PREFIX}: domain block %s", domain_block)
        self.__domain_block = domain_block


class DomainBlock(BoxLayout):
    __auth_updater: AuthUpdater
    __settings_service: SettingsService

    def __init__(
        self,
        auth_updater: AuthUpdater = AuthUpdater(),
        settings_service: SettingsService = SettingsService(),
        **kwargs,
    ):
        super().__init__(**kwargs)
        self.__auth_updater = auth_updater
        self.__settings_service = settings_service
        self.__auth_updater.register_domain_block(self)

    def on_kv_post(self, base_class):
        settings = self.__settings_service.get()
        self.ids.domain.text = settings.domain

    def change_domain(self, domain: str):
        self.__auth_updater.trigger_delayed_save()


class ClientIdBlock(BoxLayout):
    __auth_updater: AuthUpdater
    __settings_service: SettingsService

    def __init__(
        self,
        auth_updater: AuthUpdater = AuthUpdater(),
        settings_service: SettingsService = SettingsService(),
        **kwargs,
    ):
        super().__init__(**kwargs)
        self.__auth_updater = auth_updater
        self.__settings_service = settings_service
        self.__auth_updater.register_client_id_block(self)

    def on_kv_post(self, base_class):
        settings = self.__settings_service.get()
        self.ids.client_id.text = settings.client_id

    def change_client_id(self, client_id: str):
        self.__auth_updater.trigger_delayed_save()
