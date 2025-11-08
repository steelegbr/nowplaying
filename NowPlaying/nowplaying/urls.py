from django.contrib import admin
from django.urls import path, include
from nowplaying.views import static

urlpatterns = [
    path("", static.index, name="index"),
    path("admin/", admin.site.urls),
    path("oidc/", include("mozilla_django_oidc.urls")),
]
