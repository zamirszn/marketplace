from django.urls import include, path

from .views import CustomTokenObtainPairView, UserCreateView
from rest_framework_nested import routers

from . import views




urlpatterns = [
    path("auth/jwt/create/", CustomTokenObtainPairView.as_view(), name="custom_jwt_create"),
    path("auth/signup/", UserCreateView.as_view(), name="user-signup"),
    path("auth/verify-otp/", views.verify_otp, name="verify-otp"),
    path("auth/request-otp/", views.get_otp_code, name="request-otp"),
    path("auth/", include("djoser.urls")),
    path("auth/", include("djoser.urls.jwt")),
    path("profile/", views.ProfileView.as_view(), name="user-profile"),
]
