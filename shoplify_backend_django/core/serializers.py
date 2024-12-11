from djoser.serializers import UserCreateSerializer


class UserSerializer(UserCreateSerializer):
    class Meta(UserCreateSerializer.Meta):
        fields = ["id", "email", "full_name", "password"]
