from mozilla_django_oidc.auth import OIDCAuthenticationBackend
from django.conf import settings


class NowPlayingOIDCAuthenticationBackend(OIDCAuthenticationBackend):
    def create_user(self, claims):
        user = super().create_user(claims)
        self._apply_admin_flag(user, claims)
        user.save()
        return user

    def update_user(self, user, claims):
        user = super().update_user(user, claims)
        self._apply_admin_flag(user, claims)
        user.save()
        return user

    def _apply_admin_flag(self, user, claims):
        has_admin = False

        roles = claims.get(f"{settings.ROLES_NAMESPACE}roles", [])
        has_admin = "Now Playing Admin" in roles

        user.is_staff = bool(has_admin)
        user.is_superuser = bool(has_admin)
