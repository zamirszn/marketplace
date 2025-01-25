from django.urls import include, path

from .views import OTPVerificationView, UserCreateView
from rest_framework_nested import routers

from . import views




urlpatterns = [
    path("auth/signup/", UserCreateView.as_view(), name="user-signup"),
    path("auth/otp-verify/", OTPVerificationView.as_view(), name="otp-verify"),
    path("auth/", include("djoser.urls")),
    path("auth/", include("djoser.urls.jwt")),
    path("profile/", views.ProfileView.as_view(), name="user-profile"),
]
