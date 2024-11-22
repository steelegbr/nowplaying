from kivy.properties import ObjectProperty, StringProperty
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.popup import Popup
from services.settings import SettingsService
from typing import List


class NowPlayingFileModal(BoxLayout):
    select = ObjectProperty(None)
    cancel = ObjectProperty(None)


class NowPlayingFileChooser(BoxLayout):
    __popup: Popup
    __settings_service: SettingsService

    path = StringProperty("")

    def __init__(
        self,
        settings_service: SettingsService = SettingsService(),
        **kwargs,
    ):
        super().__init__(**kwargs)
        self.__settings_service = settings_service
        self.path = self.__settings_service.get().now_playing_file

    def choose_file(self):
        modal = NowPlayingFileModal(select=self.select, cancel=self.cancel)
        self.__popup = Popup(
            title="Choose now playing file", content=modal, size_hint=(0.9, 0.9)
        )
        self.__popup.open()

    def select(self, selection: List[str]):
        if len(selection) > 0:
            self.path = selection[0]
            settings = self.__settings_service.get()
            settings.now_playing_file = selection[0]
            self.__settings_service.save(settings)
        self.__popup.dismiss()

    def cancel(self):
        self.__popup.dismiss()
