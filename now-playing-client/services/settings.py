from configparser import ConfigParser
from models.settings import Settings
from os import environ
from services.logging import get_logger, Logger


class SettingsService:
    __logger: Logger
    __settings_file: str = environ.get("SETTINGS_FILE") or "settings.ini"

    INDEX_SETTINGS = "SETTINGS"
    LOG_PREFIX = "Settings Service"

    def __init__(self, logger: Logger = get_logger(__name__)) -> None:
        self.__logger = logger

    def get(self) -> Settings:
        self.__logger.info(
            f"{self.LOG_PREFIX}: attempting to read settings from %s",
            self.__settings_file,
        )

        try:
            config_obj = ConfigParser()
            config_obj.read(self.__settings_file)
            return Settings(**config_obj[self.INDEX_SETTINGS])
        except KeyError as ex:
            self.__logger.warning(
                f"{self.LOG_PREFIX}: %s key missing from settings file",
                self.INDEX_SETTINGS,
            )

        self.__logger.warning(f"{self.LOG_PREFIX}: fall back to default settings")
        return Settings()

    def save(self, settings: Settings):
        self.__logger.info(
            f"{self.LOG_PREFIX}: attempt to write settings to %s", self.__settings_file
        )

        config_obj = ConfigParser()
        config_obj[self.INDEX_SETTINGS] = settings.model_dump()

        try:
            with open(self.__settings_file, "w") as settings_handle:
                config_obj.write(settings_handle)
        except (IOError, OSError, PermissionError) as ex:
            self.__logger.error(
                f"{self.LOG_PREFIX}: failed to write settings to %s because of %s",
                self.__settings_file,
                ex,
            )
