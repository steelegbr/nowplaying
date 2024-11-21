from services import get_logger, Logger


class AuthenticationService:
    __logger: Logger

    instance = None
    LOG_PREFIX = "Authentication Service"

    def __new__(cls, logger: Logger = get_logger(__name__)):
        if not hasattr(cls, "instance"):
            cls.instance = super(AuthenticationService, cls).__new__(cls)
            cls.instance.__logger = logger
        return cls.instance
