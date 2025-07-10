"""
URL configuration for shoplify_backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.conf import settings
from django.contrib import admin
from django.urls import path, include
from django.conf.urls.static import static
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from rest_framework import permissions
from django.views.generic import TemplateView
from rest_framework_simplejwt.authentication import JWTAuthentication



schema_view = get_schema_view(
    openapi.Info(
        title="Shoplify API",
        default_version='v1',
        description="API Documentation for Shoplify Project",
    ),
    public=False,  # Set to False to restrict access
    permission_classes=(permissions.IsAuthenticated,),
    authentication_classes=(JWTAuthentication,),
)


urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/", include("shoplify_api.urls")),
    path('api-docs/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    path("", include("core.urls")),
]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


admin.site.site_title = "Shoplify"
admin.site.site_header = "Shoplify administration"
admin.site.index_title = "Site administration"
