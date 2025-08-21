from djoser.serializers import UserCreateSerializer
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer


from .models import Profile


class UserCreateSerializer(UserCreateSerializer):
    class Meta(UserCreateSerializer.Meta):
        fields = ["id", "email", "full_name", "password"]

class ProfileSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='owner.full_name', read_only=False)
    email = serializers.CharField(source='owner.email', read_only=False)

    class Meta:
        model = Profile
        fields = ["id", "phone", "profilePicture", "shipping_address", "notifications_enabled", "full_name", "email"]

    def update(self, instance, validated_data):
        owner_data = validated_data.pop('owner', {})
        for attr, value in owner_data.items():
            setattr(instance.owner, attr, value)
        instance.owner.save()
        return super().update(instance, validated_data)

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




