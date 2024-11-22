from models.dto.nowplaying import NowPlayingDto
from kivy.clock import Clock, partial
from kivy.properties import ObjectProperty, StringProperty
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.popup import Popup
from services.file import FileMonitorService, FileMonitorServiceState
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


class ArtistBlock(BoxLayout):
    __file_monitor_service: FileMonitorService

    artist = StringProperty("")

    def __init__(
        self,
        file_monitor_service: FileMonitorService = FileMonitorService(),
        **kwargs,
    ):
        super().__init__(**kwargs)
        self.__file_monitor_service = file_monitor_service
        self.__file_monitor_service.register_callback(self.__file_monitor_callback)

    def __file_monitor_callback(
        self, state: FileMonitorServiceState, now_playing: NowPlayingDto
    ):
        # Move the update to the Kivy thread
        Clock.schedule_once(
            partial(self.__update_artist, now_playing),
            0.1,
        )

    def __update_artist(self, now_playing: NowPlayingDto, dt):
        self.artist = now_playing.artist if now_playing else ""


class TitleBlock(BoxLayout):
    __file_monitor_service: FileMonitorService

    title = StringProperty("")

    def __init__(
        self,
        file_monitor_service: FileMonitorService = FileMonitorService(),
        **kwargs,
    ):
        super().__init__(**kwargs)
        self.__file_monitor_service = file_monitor_service
        self.__file_monitor_service.register_callback(self.__file_monitor_callback)

    def __file_monitor_callback(
        self, state: FileMonitorServiceState, now_playing: NowPlayingDto
    ):
        # Move the update to the Kivy thread
        Clock.schedule_once(
            partial(self.__update_title, now_playing),
            0.1,
        )

    def __update_title(self, now_playing: NowPlayingDto, dt):
        self.title = now_playing.title if now_playing else ""


class YearBlock(BoxLayout):
    __file_monitor_service: FileMonitorService

    year = StringProperty("")

    def __init__(
        self,
        file_monitor_service: FileMonitorService = FileMonitorService(),
        **kwargs,
    ):
        super().__init__(**kwargs)
        self.__file_monitor_service = file_monitor_service
        self.__file_monitor_service.register_callback(self.__file_monitor_callback)

    def __file_monitor_callback(
        self, state: FileMonitorServiceState, now_playing: NowPlayingDto
    ):
        # Move the update to the Kivy thread
        Clock.schedule_once(
            partial(self.__update_year, now_playing),
            0.1,
        )

    def __update_year(self, now_playing: NowPlayingDto, dt):
        self.year = str(now_playing.year) if now_playing and now_playing.year else ""
