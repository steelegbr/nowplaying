from kivy.properties import ListProperty, StringProperty
from kivy.uix.boxlayout import BoxLayout
from models.dto.nowplaying import NowPlayingDto
from services.file import FileMonitorService, FileMonitorServiceState
from typing import Dict, List


class FileMonitorActionBlock(BoxLayout):
    __file_monitor_service: FileMonitorService

    button_text = StringProperty("")
    status_colour = ListProperty([1, 1, 1, 1])
    status_text = StringProperty("")

    FILE_MONITOR_SERVICE_BUTTON_TEXT_MAP: Dict[FileMonitorServiceState, str] = {
        FileMonitorServiceState.Error: "Start",
        FileMonitorServiceState.Started: "Stop",
        FileMonitorServiceState.Stopped: "Start",
    }

    FILE_MONITOR_SERVICE_COLOUR_MAP: Dict[FileMonitorServiceState, List[float]] = {
        FileMonitorServiceState.Error: [0.94, 0.55, 0.2, 1],
        FileMonitorServiceState.Started: [0.13, 0.55, 0.1, 1],
        FileMonitorServiceState.Stopped: [1, 0, 0, 1],
    }

    FILE_MONITOR_SERVICE_MAP: Dict[FileMonitorServiceState, str] = {
        FileMonitorServiceState.Error: "Error",
        FileMonitorServiceState.Started: "Started",
        FileMonitorServiceState.Stopped: "Stopped",
    }

    def __init__(
        self, file_monitor_service: FileMonitorService = FileMonitorService(), **kwargs
    ):
        super().__init__(**kwargs)
        self.__file_monitor_service = file_monitor_service
        self.__file_monitor_service.register_callback(
            self.__file_monitor_service_callback
        )

    def __file_monitor_service_callback(
        self, state: FileMonitorServiceState, now_playing: NowPlayingDto
    ):
        self.button_text = self.FILE_MONITOR_SERVICE_BUTTON_TEXT_MAP[state]
        self.status_colour = self.FILE_MONITOR_SERVICE_COLOUR_MAP[state]
        self.status_text = self.FILE_MONITOR_SERVICE_MAP[state]

    def toggle_file_monitor(self):
        self.__file_monitor_service.toggle_service()
