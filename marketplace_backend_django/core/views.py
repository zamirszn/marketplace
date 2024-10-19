from datetime import datetime
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth import get_user_model
from django.core.mail import send_mail, BadHeaderError
from smtplib import SMTPException
from django.conf import settings
from .serializers import UserSerializer
from django.utils import timezone


User = get_user_model()


class UserCreateView(APIView):
    def post(self, request, *args, **kwargs):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            otp = user.generate_otp()

            try:
                send_mail(
                    "Your OTP for account verification",
                    f"Your OTP is {otp}",
                    settings.DEFAULT_FROM_EMAIL,
                    [user.email],
                    fail_silently=False,
                )
                return Response(
                    {"message": "OTP has been sent to your email"},
                    status=status.HTTP_201_CREATED,
                )
            except BadHeaderError:
                return Response(
                    {"error": "Invalid header found in the email."},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            except SMTPException:
                return Response(
                    {
                        "error": "There was an error sending the OTP email. Please try again later."
                    },
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR,
                )
            except Exception as e:
                return Response(
                    {"error": f"An unexpected error occurred: {str(e)}"},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR,
                )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class OTPVerificationView(APIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get("email")
        otp = request.data.get("otp")

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response(
                {"error": "User not found"}, status=status.HTTP_404_NOT_FOUND
            )

        if user.otp == otp and user.otp_expiry > datetime.now():
            user.is_active = True  # Activate user
            user.otp = None  # Clear OTP after successful verification
            user.otp_expiry = None
            user.save()

            return Response(
                {"detail": "Account verified successfully"}, status=status.HTTP_200_OK
            )
        else:
            return Response(
                {"error": "Invalid or expired OTP"}, status=status.HTTP_400_BAD_REQUEST
            )
