from services import get_logger, Logger


class AuthenticationService:
    __instance = None
    __logger: Logger

    def __init__(self) -> None:
        raise RuntimeError(
            f"Direct instantiation not permitted, call {self.__class__.__name__}.instance()"
        )

    @classmethod
    def instance(cls, logger: Logger = get_logger(__name__)):
        if cls.__instance is None:
            cls.__instance = cls.__new__(cls)
            cls.__logger = logger
        return cls.__instance
