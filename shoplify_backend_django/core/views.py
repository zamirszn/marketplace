from django.utils import timezone
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth import get_user_model
from django.core.mail import send_mail, BadHeaderError
from smtplib import SMTPException
from django.conf import settings
from .serializers import CustomJWTSerializer, ProfileSerializer, UserSerializer
from django.utils import timezone
from .models import *
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.viewsets import ModelViewSet
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from djoser.views import TokenCreateView
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.decorators import api_view
from django.utils.crypto import get_random_string
from django.contrib.auth.hashers import make_password



User = get_user_model()


@api_view(["POST"])
def reset_password(request):
    email = request.data.get("email")
    otp = request.data.get("otp")
    new_password = request.data.get("new_password")

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    # Validate OTP
    if user.password_reset_otp == str(otp) or user.password_reset_otp_expiry > timezone.now():

    # Reset the password
        user.password = make_password(new_password)  # Hash the new password
        user.password_reset_otp = None  # Clear OTP after successful reset
        user.password_reset_otp_expiry = None
        user.save()
        return Response({"message": "Password reset successful"}, status=status.HTTP_200_OK)
    else:
        return Response({"error": "Invalid or expired OTP"}, status=status.HTTP_400_BAD_REQUEST)




@api_view(["POST"])
def request_password_reset_otp(request):
    email = request.data.get("email")
    print(email)

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    # Generate a 6-digit OTP
    reset_otp = get_random_string(length=4, allowed_chars="0123456789")
    user.password_reset_otp = reset_otp
    user.password_reset_otp_expiry = timezone.now() + timezone.timedelta(minutes=10)  # OTP valid for 10 minutes
    user.save()


    try:
        # Send OTP via email
        send_mail(
            "Password Reset OTP",
            f"Your OTP for password reset is: {reset_otp}",
            settings.DEFAULT_FROM_EMAIL,
            [user.email],
            fail_silently=False,
        )
        return Response({"message": "Password reset OTP has been sent to your email"}, status=status.HTTP_200_OK)
    
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



class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomJWTSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)

        try:
            serializer.is_valid(raise_exception=True)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_401_UNAUTHORIZED)

        return Response(serializer.validated_data, status=status.HTTP_200_OK)    



class UserCreateView(APIView):
    def post(self, request, *args, **kwargs):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            user.is_active=True
            user.save()

            # Create a profile for the user when they sign up
            Profile.objects.create(owner=user)

            return Response(
                {"message": "User created successfully."},
                status=status.HTTP_201_CREATED,
            )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["POST"])
def request_email_verification_otp(request):
    email = request.data.get("email")        
    try:
        user = User.objects.get(email=email)
        otp = user.generate_email_verification_otp()
        send_mail(
                    "Your OTP for account verification",
                    f"Your OTP is {otp}",
                    settings.DEFAULT_FROM_EMAIL,
                    [user.email],
                    fail_silently=False,
                )
        return Response(
                {"message": "Email verfication OTP has been sent to your email"},
                status=status.HTTP_200_OK,
            )
    
    except User.DoesNotExist:
        return Response(
            {"error": "User not found"}, status=status.HTTP_404_NOT_FOUND
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



@api_view(["POST"])
def verify_email(request):
    email = request.data.get("email")
    otp = request.data.get("otp")

    if not email or not otp:
        return Response({"error": "Email and OTP are required"}, status=status.HTTP_400_BAD_REQUEST)

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    # Verify OTP and expiry
    if user.email_verification_otp == str(otp)  and user.email_verification_otp_expiry > timezone.now():
        # Mark email as verified
        user.email_verified = True
        user.email_verification_otp = None  # Clear OTP after successful verification
        user.email_verification_otp_expiry = None
        user.save()

        # Generate JWT tokens
        refresh = RefreshToken.for_user(user)

        return Response({
            "message": "Account verified successfully",
            "email_verified": True,
            "access": str(refresh.access_token),
            "refresh": str(refresh)
        }, status=status.HTTP_200_OK)
    else:
        return Response({"error": "Invalid or expired OTP"}, status=status.HTTP_400_BAD_REQUEST)


class ProfileView(APIView):
    serializer_class = ProfileSerializer
    permission_classes = [IsAuthenticated]
    parser_classes = (MultiPartParser, FormParser)

    def get(self, request, *args, **kwargs):
        profile = Profile.objects.filter(owner=request.user).first()  # Get the user's profile
        if not profile:
            return Response({"detail": "Profile not found."}, status=status.HTTP_404_NOT_FOUND)
        profile_serializer = ProfileSerializer(profile)
        return Response(profile_serializer.data)

    def post(self, request, *args, **kwargs):
        profile = Profile.objects.filter(owner=request.user).first()
        if profile:
            # Update existing profile
            serializer = self.serializer_class(profile, data=request.data, partial=True)
        else:
            # Create a new profile
            serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():
            serializer.save(owner=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED if not profile else status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)