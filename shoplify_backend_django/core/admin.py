from django.contrib import admin
from .models import Profile, User

from django.contrib.auth.models import Group

from unfold.admin import ModelAdmin
from import_export.admin import ImportExportModelAdmin
from unfold.contrib.import_export.forms import ExportForm, ImportForm, SelectableFieldsExportForm



admin.site.unregister(Group)



@admin.register(User)
class UserAdmin(ModelAdmin, ImportExportModelAdmin):

    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm

    class Meta:
        models = User

    list_per_page = 100

    list_filter = [
        "is_active",
        "is_superuser",
        "is_staff",
        "date_joined",
        "last_login",
        "email_verified",
        "account_blocked"
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
        "email_verified",
                "account_blocked"

    ]
    search_fields = [
        "id",
        "email",
        "full_name",
        "email_verified",
                "account_blocked"

    ]

@admin.register(Profile)
class ProfileAdmin(ModelAdmin, ImportExportModelAdmin):

    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm


    class Meta:
        models = Profile

    search_fields = [
        "id",
        "owner",
        "phone",
        "shipping_address"
    ]
    list_display = [
    "owner","id","phone", "shipping_address", "notifications_enabled",
    ]

    list_filter = [
        "notifications_enabled"
    ]

    list_per_page = 100

