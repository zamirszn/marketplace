import random
from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager, PermissionsMixin
from django.utils import timezone
from cloudinary.models import CloudinaryField
from django.conf import settings


class UserManager(BaseUserManager):
    """Define a model manager for User model with no username field."""

    def _create_user(self, email, password=None, **extra_field):
        if not email:
            raise ValueError("The given email must be set")
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_field)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, email, password=None, **extra_fields):
        extra_fields.setdefault("is_staff", False)
        extra_fields.setdefault("is_superuser", False)
        return self._create_user(email, password, **extra_fields)

    def create_superuser(self, email, password=None, **extra_fields):
        """Create and save a SuperUser with the given email and password."""
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)

        if extra_fields.get("is_staff") is not True:
            raise ValueError("Superuser must have is_staff=True.")
        if extra_fields.get("is_superuser") is not True:
            raise ValueError("Superuser must have is_superuser=True.")

        return self._create_user(email, password, **extra_fields)


class User(AbstractUser, PermissionsMixin):
    email = models.EmailField(blank=True, default="", unique=True)
    full_name = models.CharField(
        max_length=225,
        blank=True,
        default="",
    )
    is_active = models.BooleanField(default=True)
    is_superuser = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    date_joined = models.DateTimeField(auto_now=True)
    last_login = models.DateTimeField(blank=True, null=True, auto_now_add=True)
    username = None
    first_name = None
    last_name = None
    objects = UserManager()
    USERNAME_FIELD = "email"
    EMAIL_FIELD = "email"
    REQUIRED_FIELDS = []
    otp = models.CharField(max_length=6, blank=True, null=True)
    otp_expiry = models.DateTimeField(blank=True, null=True)

    def generate_otp(self):
        otp = str(random.randint(100000, 999999))  # Generate a 6-digit OTP
        self.otp = otp
        self.otp_expiry = timezone.now() + timezone.timedelta(
            minutes=10
        )  # OTP expires in 10 minutes
        self.save()
        return otp

    class Meta:
        verbose_name = "User"
        verbose_name_plural = "Users"


class Profile(models.Model):
    name = models.CharField(max_length=225)
    bio = models.TextField()
    picture = models.ImageField(blank=True, null=True)

    picture = CloudinaryField(
        "profile_images",
        blank=True,
        null=True,
    )
    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, blank=True, null=True
    )
    phone = models.CharField(unique=True, max_length=20, null=True, blank= True)
    shipping_address = models.TextField(null=True, blank= True)
    billing_address = models.TextField(null=True, blank= True)
    notifications_enabled = models.BooleanField(default=True)

    def __str__(self) -> str:
        return self.name

    class Meta:
        verbose_name = "Profile"
        verbose_name_plural = "Profiles"
