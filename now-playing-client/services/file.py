from enum import StrEnum
from models.dto.nowplaying import NowPlayingDto
from re import search
from services.api import ApiService
from services.logging import get_logger, Logger
from services.settings import SettingsService
from typing import Callable, List
from watchdog.events import DirModifiedEvent, FileModifiedEvent, FileSystemEventHandler
from watchdog.observers import Observer, ObserverType


class FileMonitorServiceState(StrEnum):
    Error = "ERROR"
    Started = "STARTED"
    Stopped = "STOPPED"


class FileMonitorService(FileSystemEventHandler):
    __api_service: ApiService
    __callbacks: List[Callable[[FileMonitorServiceState, NowPlayingDto], None]]
    __now_playing: NowPlayingDto
    __observer: ObserverType
    __logger: Logger
    __settings_service: SettingsService
    __state: FileMonitorServiceState = FileMonitorServiceState.Stopped

    instance = None
    LOG_PREFIX = "File Monitor Service"

    def __new__(
        cls,
        api_service: ApiService = ApiService(),
        logger: Logger = get_logger(__name__),
        settings_service: SettingsService = SettingsService(),
    ):
        if not cls.instance:
            cls.instance = super(FileMonitorService, cls).__new__(cls)
            cls.instance.__api_service = api_service
            cls.instance.__callbacks = []
            cls.instance.__logger = logger
            cls.instance.__settings_service = settings_service
            cls.instance.__now_playing = None
        return cls.instance

    def __set_state(self, state: FileMonitorServiceState):
        self.__state = state
        self.__logger.info("%s: change state to %s", self.LOG_PREFIX, state)
        self.__update_callbacks()

    def __update_callbacks(self):
        for callback in self.__callbacks:
            callback(self.__state, self.__now_playing)

    def get_state(self) -> FileMonitorServiceState:
        return self.__state

    def deregister_callback(
        self, callback: Callable[[FileMonitorServiceState, NowPlayingDto], None]
    ):
        if callback in self.__callbacks:
            self.__callbacks.remove(callback)
        self.__logger.info("%s: deregister callback %s", self.LOG_PREFIX, callback)

    def register_callback(
        self, callback: Callable[[FileMonitorServiceState, NowPlayingDto], None]
    ):
        self.__callbacks.append(callback)
        self.__logger.info("%s: register callback %s", self.LOG_PREFIX, callback)
        callback(self.__state, self.__now_playing)

    def toggle_service(self):
        if self.get_state() in [
            FileMonitorServiceState.Error,
            FileMonitorServiceState.Stopped,
        ]:
            self.__set_state(FileMonitorServiceState.Started)
            settings = self.__settings_service.get()

            self.__observer = Observer()
            self.__observer.schedule(
                self, path=settings.now_playing_file, recursive=True
            )
            self.__observer.start()
        else:
            self.__set_state(FileMonitorServiceState.Stopped)
            self.__observer.stop()
            self.__observer.join()

    def on_modified(self, event: DirModifiedEvent | FileModifiedEvent) -> None:
        self.__logger.info("%s: now playing file change detected", self.LOG_PREFIX)
        with open(event.src_path, encoding="utf-8") as now_playing_handle:
            file_content = now_playing_handle.read()
            matches = search(r"(.+) - (.+) \((\d{0,4})\)", file_content)
            matches_without_year = search(r"(.+) - (.+)", file_content)

        if matches:
            try:
                year = int(matches.group(3))
            except ValueError:
                year = None

            self.__now_playing = NowPlayingDto(
                artist=matches.group(1), title=matches.group(2), year=year
            )
            self.__logger.info(
                "%s: detected now playing %s", self.LOG_PREFIX, self.__now_playing
            )
            self.__update_callbacks()
        elif matches_without_year:
            self.__now_playing = NowPlayingDto(
                artist=matches_without_year.group(1),
                title=matches_without_year.group(2),
            )
            self.__logger.info(
                "%s: detected now playing %s without year",
                self.LOG_PREFIX,
                self.__now_playing,
            )
            self.__update_callbacks()
        else:
            self.__now_playing = None
            self.__update_callbacks()

        self.__api_service.update_now_playing(self.__now_playing)
