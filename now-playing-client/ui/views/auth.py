from kivy.uix.boxlayout import BoxLayout
from services.settings import SettingsService


class DomainBlock(BoxLayout):
    __settings_service: SettingsService

    def __init__(self, settings_service: SettingsService = SettingsService(), **kwargs):
        super().__init__(**kwargs)
        self.__settings_service = settings_service

    def on_start(self, **kwargs):
        settings = self.__settings_service.get()
        self.ids.domain.text = settings.domain

    def change_domain(self, domain: str):
        settings = self.__settings_service.get()
        settings.domain = domain
        self.__settings_service.save(settings)


class ClientIdBlock(BoxLayout):
    __settings_service: SettingsService

    def __init__(self, settings_service: SettingsService = SettingsService(), **kwargs):
        super().__init__(**kwargs)
        self.__settings_service = settings_service

    def on_start(self, **kwargs):
        settings = self.__settings_service.get()
        self.ids.client_id.text = settings.client_id

    def change_client_id(self, client_id: str):
        settings = self.__settings_service.get()
        settings.client_id = client_id
        self.__settings_service.save(settings)
