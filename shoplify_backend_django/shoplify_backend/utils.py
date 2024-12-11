import random

from django.conf import settings
from django.utils.translation import gettext_lazy as _

from shoplify_backend_django.shoplify_api.models import Order


def environment_callback(request):
    if settings.DEBUG:
        return [_("Development"), "info"]

    return [_("Production"), "warning"]
