from enum import StrEnum
from models.dto.nowplaying import NowPlayingDto
from services.logging import get_logger, Logger
from typing import Callable, List


class FileMonitorServiceState(StrEnum):
    Error = "ERROR"
    Started = "STARTED"
    Stopped = "STOPPED"


class FileMonitorService:
    __callbacks: List[Callable[[FileMonitorServiceState, NowPlayingDto], None]]
    __now_playing: NowPlayingDto
    __logger: Logger
    __state: FileMonitorServiceState = FileMonitorServiceState.Stopped

    instance = None
    LOG_PREFIX = "File Monitor Service"

    def __new__(
        cls,
        logger: Logger = get_logger(__name__),
    ):
        if not cls.instance:
            cls.instance = super(FileMonitorService, cls).__new__(cls)
            cls.instance.__callbacks = []
            cls.instance.__logger = logger
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
