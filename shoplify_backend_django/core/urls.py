from django.urls import include, path

from .views import CustomTokenObtainPairView, UserCreateView
from rest_framework_nested import routers

from . import views




urlpatterns = [
    path("auth/jwt/create/", CustomTokenObtainPairView.as_view(), name="custom-jwt-create"),
    path("auth/signup/", UserCreateView.as_view(), name="user-signup"),
    path("auth/verify-email/", views.verify_email, name="verify-otp"),
    path("auth/request-email-verification-otp/", views.request_email_verification_otp, name="request-otp"),
    path("auth/request-password-reset-otp/", views.request_password_reset_otp, name="request-password-otp"),
    path("auth/reset-password/", views.reset_password, name="reset-password"),
    path("auth/", include("djoser.urls")),
    path("auth/", include("djoser.urls.jwt")),
    path("profile/", views.ProfileView.as_view(), name="user-profile"),
]
