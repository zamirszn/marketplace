from django.contrib import admin
from .models import User

from django.contrib.auth.models import Group

admin.site.unregister(Group)


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    class Meta:
        models = User

    list_per_page = 100

    list_filter = [
        "is_active",
        "is_superuser",
        "is_staff",
        "date_joined",
        "last_login",
    ]
    list_display = [
        "email",
        "id",
        "full_name",
        "is_active",
        "is_superuser",
        "is_staff",
        "date_joined",
        "last_login",
    ]
    search_fields = [
        "id",
        "email",
        "full_name",
    ]
