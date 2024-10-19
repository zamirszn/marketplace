import random

from django.conf import settings
from django.utils.translation import gettext_lazy as _

from marketplace_backend_django.market_place_api.models import Order


def environment_callback(request):
    if settings.DEBUG:
        return [_("Development"), "info"]

    return [_("Production"), "warning"]
