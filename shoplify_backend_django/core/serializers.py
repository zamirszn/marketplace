from djoser.serializers import UserCreateSerializer
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer


from .models import Profile


class UserSerializer(UserCreateSerializer):
    class Meta(UserCreateSerializer.Meta):
        fields = ["id", "email", "full_name", "password"]



class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ["id", "name", "bio", "picture"]



class CustomJWTSerializer(TokenObtainPairSerializer):
    
    def validate(self, attrs):
        data = super().validate(attrs)
        user = self.user

        if user.account_blocked:
            return {
                "success": False,
                "message": "Your account has been restricted, please contact support.",
                "account_blocked": True
            }

        if not user.email_verified:
            return {
                "success": False,
                "message": "Email is not verified.",
                "email_verified": False,
                "email": user.email
            }
        

        data["email_verified"] = True
        data["account_blocked"] = False
      

        return data




