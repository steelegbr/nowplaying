from services.logging import get_logger, Logger
from services.settings import SettingsService


class ApiService:
    __logger: Logger
    __settings_service: SettingsService

    instance = None
    LOG_PREFIX = "API Service"

    def __new__(
        cls,
        logger: Logger = get_logger(__name__),
        settings_service: SettingsService = SettingsService(),
    ):
        if not cls.instance:
            cls.instance = super(ApiService, cls).__new__(cls)
            cls.instance.__logger = logger
            cls.instance.__settings_service = settings_service
        return cls.instance
