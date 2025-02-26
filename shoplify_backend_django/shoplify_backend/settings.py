"""
Django settings for shoplify_backend project.

Generated by 'django-admin startproject' using Django 5.1.

For more information on this file, see
https://docs.djangoproject.com/en/5.1/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/5.1/ref/settings/
"""

from datetime import timedelta
import os
from pathlib import Path
import cloudinary
import os
import dj_database_url
from django.core.management.utils import get_random_secret_key
from django.urls import reverse_lazy
import environ
from django.templatetags.static import static
from django.utils.translation import gettext_lazy as lzy
import stripe


# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


env = environ.Env()

environ.Env.read_env(BASE_DIR / ".env")

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!

DEBUG = env.bool("DEBUG", default=False)

# SECURITY WARNING: don't run with debug turned on in production!


SECRET_KEY = env.str("SECRET_KEY", default=get_random_secret_key())


ALLOWED_HOSTS = env.list("ALLOWED_HOSTS", default=["127.0.0.1", "localhost"])


EMAIL_BACKEND = env.str("EMAIL_BACKEND")
EMAIL_HOST = env.str("EMAIL_HOST")
EMAIL_PORT = env("EMAIL_PORT")
EMAIL_USE_TLS = env.bool(
    "EMAIL_USE_TLS",
    default=True,
)
EMAIL_HOST_USER = env.str("EMAIL_HOST_USER")
EMAIL_HOST_PASSWORD = env.str("EMAIL_HOST_PASSWORD")
DEFAULT_FROM_EMAIL = env.str("DEFAULT_FROM_EMAIL")


# Application definition

INSTALLED_APPS = [
    "unfold",  # before django.contrib.admin
    "unfold.contrib.filters",  # optional, if special filters are needed
    "unfold.contrib.forms",  # optional, if special form elements are needed
    "unfold.contrib.inlines",  # optional, if special inlines are needed
    # "unfold.contrib.import_export",  # optional, if django-import-export package is used
    # "unfold.contrib.guardian",  # optional, if django-guardian package is used
    # "unfold.contrib.simple_history",  # optional, if django-simple-history package is used
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "cloudinary",
    "whitenoise.runserver_nostatic",
    "django.contrib.staticfiles",
    "shoplify_api",
    "core",
    "django_filters",
    "rest_framework",
    "djoser",
    "rest_framework_swagger",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

APPEND_SLASH = True

ROOT_URLCONF = "shoplify_backend.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [os.path.join(BASE_DIR, "templates")],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "shoplify_backend.wsgi.application"


# Database
# https://docs.djangoproject.com/en/5.1/ref/settings/#databases


DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "db.sqlite3",
    }
}

# DATABASES = {
#     "default": dj_database_url.parse(os.environ.get("DATABASE_URL"))
# }


SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")

# Password validation
# https://docs.djangoproject.com/en/5.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.1/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.1/howto/static-files/


STATIC_URL = "static/"
STATIC_ROOT = BASE_DIR / "staticfiles"  # <-- Updated!

STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"

# STATICFILES_DIRS = [
#     os.path.join(BASE_DIR, "static"),
# ]


MEDIA_URL = "/media/"  # This is the URL prefix for media files
# MEDIA_ROOT = os.path.join(BASE_DIR, "media/")

# DEFAULT_FILE_STORAGE = "cloudinary_storage.storage.MediaCloudinaryStorage"

# Default primary key field type
# https://docs.djangoproject.com/en/5.1/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

AUTH_USER_MODEL = "core.User"

REST_FRAMEWORK = {
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 50,
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
}

SIMPLE_JWT = {
    "AUTH_HEADER_TYPES": ("JWT",),
    "ACCESS_TOKEN_LIFETIME": timedelta(days=10),
    # "REFRESH_TOKEN_LIFETIME": timedelta(days=10),
}

DJOSER = {
    "SERIALIZERS": {
        "user_create": "core.serializers.UserSerializer",
        "token_obtain_pair": "core.serializers.CustomJWTSerializer", 
    },
    "SEND_ACTIVATION_EMAIL": True,
    "SEND_CONFIRMATION_EMAIL": True,
    "LOGOUT_ON_PASSWORD_CHANGE": True,
    "PASSWORD_CHANGED_EMAIL_CONFIRMATION": True,
    "ACTIVATION_URL": "activate/{uid}/{token}/",
    "EMAIL": {
        "activation": "djoser.email.ActivationEmail",
    },
}


cloudinary.config(
    cloud_name=env("CLOUDINARY_CLOUD_NAME"),
    api_key=env("CLOUDINARY_API_KEY"),
    api_secret=env("CLOUDINARY_API_SECRET"),
)


STRIPE_SECRET_KEY = env("STRIPE_SK")
STRIPE_PUBLISHABLE_KEY = env("STRIPE_PK")

stripe.api_key = STRIPE_SECRET_KEY


UNFOLD = {
    "SITE_URL": "/",
    "SITE_SYMBOL": "settings",  # symbol from icon set
    "SHOW_HISTORY": True,  # show/hide "History" button, default: True
    "SHOW_VIEW_ON_SITE": True,  # show/hide "View on site" button, default: True
    "STYLES": [
        lambda request: static("css/styles.css"),
    ],
    "ENVIRONMENT": "shoplify_backend.utils.environment_callback",
    "DASHBOARD_CALLBACK": "shoplify_api.views.dashboard_callback",
    "COLORS": {
        "primary": {
            "50": "250 245 255",
            "100": "243 232 255",
            "200": "233 213 255",
            "300": "216 180 254",
            "400": "192 132 252",
            "500": "168 85 247",
            "600": "147 51 234",
            "700": "126 34 206",
            "800": "107 33 168",
            "900": "88 28 135",
            "950": "59 7 100",
        },
    },
    # "EXTENSIONS": {
    #     "modeltranslation": {
    #         "flags": {
    #             "en": "🇬🇧",
    #             "fr": "🇫🇷",
    #             "nl": "🇧🇪",
    #         },
    #     },
    # },
    "SIDEBAR": {
        "show_search": True,  # Search in applications and models names
        "show_all_applications": True,  # Dropdown with all applications and models
        "navigation": [
            {
                "separator": True,  # Top border
                "collapsible": False,  # Collapsible group of links
                "title": lzy("Home"),
                "items": [
                    {
                        "icon": "dashboard",
                        "title": lzy("Dashboard"),
                        "link": reverse_lazy("admin:index"),
                        # "badge": "sample_app.badge_callback",
                        "permission": lambda request: request.user.is_superuser,
                    },
                ],
            },
            {
                "separator": True,  # Top border
                "collapsible": True,  # Collapsible group of links
                "title": lzy("Accounts"),
                "items": [
                    {
                        "icon": "manage_accounts",
                        "title": lzy("Users"),
                        "link": reverse_lazy("admin:core_user_changelist"),
                        "permission": lambda request: request.user.is_superuser,
                    },
                    {
                        "icon": "account_circle",
                        "title": lzy("Profiles"),
                        "link": reverse_lazy("admin:core_profile_changelist"),
                        "permission": lambda request: request.user.is_superuser,
                    },
                ],
            },
            {
                "separator": True,  # Top border
                "collapsible": True,  # Collapsible group of links
                "title": lzy("Orders"),
                "items": [
                    {
                        "icon": "shopping_bag",
                        "title": lzy("Orders"),
                        "link": reverse_lazy("admin:shoplify_api_order_changelist"),
                        "badge": "shoplify_api.views.badge_callback",
                    },
                ],
            },
        ],
    },
    # "TABS": [
    #     {
    #         "models": ["core.User"],
    #         "items": [
    #             {
    #                 "title": lzy("Core"),
    #                 "icon": "sports_motorsports",
    #                 "link": reverse_lazy("admin:core_user_changelist"),
    #             },
    #         ],
    #     },
    # ],
}
