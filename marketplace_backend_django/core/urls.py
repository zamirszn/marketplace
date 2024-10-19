from django.urls import include, path

from .views import OTPVerificationView, UserCreateView

urlpatterns = [
    path("auth/signup/", UserCreateView.as_view(), name="user-signup"),
    path("auth/otp-verify/", OTPVerificationView.as_view(), name="otp-verify"),
    path("auth/", include("djoser.urls")),
    path("auth/", include("djoser.urls.jwt")),
]
