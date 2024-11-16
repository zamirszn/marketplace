from django.db import models
import uuid
from django.conf import settings
from cloudinary.models import CloudinaryField
from django.core.validators import MinValueValidator, MaxValueValidator


class Category(models.Model):
    title = models.CharField(max_length=225)
    category_id = models.UUIDField(
        default=uuid.uuid4, editable=False, primary_key=True, unique=True
    )
    slug = models.SlugField(default=None)
    featured_product = models.OneToOneField(
        "Product",
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name="featured_product",
    )

    def __str__(self):
        return self.title

    class Meta:
        verbose_name = "Category"
        verbose_name_plural = "Categories"


class Review(models.Model):
    product = models.ForeignKey(
        "Product",
        on_delete=models.CASCADE,
        related_name="reviews",
        null=True,
        default="",
    )

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        null=True,
    )

    date_created = models.DateTimeField(
        blank=True,
        null=True,
        auto_now_add=True,
    )
    description = models.TextField(
        blank=False,
        null=True,
    )
    rating = models.FloatField(
        validators=[MinValueValidator(1), MaxValueValidator(5)],
        null=True,
        blank=True,
        default=0,
    )

    def save(self, **args):
        if self.rating is not None:
            self.rating = round(self.rating, 1)
            super().save(**args)

    class Meta:
        unique_together = ("product", "owner")

    def __str__(self):
        return f"Review by {self.owner.email} for {self.product.name} - {self.rating} stars"


class Cart(models.Model):
    id = models.UUIDField(default=uuid.uuid4, primary_key=True)
    created_at = models.DateTimeField(auto_now_add=True)
    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT,
        related_name="carts",
        blank=True,
        null=True,
    )

    # def __str__(self):
    #     return self.id


class Product(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True, null=True)
    discount = models.BooleanField(default=False)
    old_price = models.FloatField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    category = models.ForeignKey(
        Category,
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="products",
    )
    slug = models.SlugField(default=None)
    id = models.UUIDField(
        default=uuid.uuid4, editable=False, primary_key=True, unique=True
    )
    inventory = models.IntegerField(default=1)
    flash_sales = models.BooleanField(default=False)

    def average_rating(self):
        avg_rating = self.reviews.aggregate(models.Avg("rating"))["rating__avg"]
        return round(avg_rating, 1) if avg_rating is not None else 0

    @property
    def price(self):
        if self.discount:
            new_price = self.old_price - ((20 / 100) * self.old_price)
        else:
            new_price = self.old_price
        return new_price

    def __str__(self):
        return self.slug

    class Meta:
        ordering = ["-created_at"]


class ProductImage(models.Model):

    # image = models.ImageField(
    #     "product_images",
    #     blank=True,
    #     null=True,
    # )
    image = CloudinaryField(
        "product_images",
        blank=True,
        null=True,
    )
    product = models.ForeignKey(
        Product, on_delete=models.CASCADE, related_name="images"
    )

    def __str__(self):
        return self.product.name


class CartItem(models.Model):
    cart = models.ForeignKey(
        Cart, on_delete=models.CASCADE, related_name="items", null=True, blank=True
    )
    product = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name="cart_items",
    )
    quantity = models.PositiveSmallIntegerField(default=0)

    def __str__(self):
        return str(self.cart.id)


class Order(models.Model):
    PAYMENT_STATUS_PENDING = "P"
    PAYMENT_STATUS_COMPLETE = "C"
    PAYMENT_STATUS_FAILED = "F"
    ORDER_DELIVERED = "D"

    PAYMENT_STATUS_CHOICES = [
        (PAYMENT_STATUS_PENDING, "Pending"),
        (PAYMENT_STATUS_COMPLETE, "Complete"),
        (PAYMENT_STATUS_FAILED, "Failed"),
        (ORDER_DELIVERED, "Delivered"),
    ]

    placed_at = models.DateTimeField(auto_now_add=True)
    order_status = models.CharField(
        max_length=50,
        choices=PAYMENT_STATUS_CHOICES,
        default=PAYMENT_STATUS_PENDING,
    )
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.PROTECT)

    def __str__(self):
        return self.owner.email + " - " + str(self.placed_at)

    @property
    def total_price(self):
        items = self.items.all()

        total = sum([item.quantity * item.product.price for item in items])
        return total


class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.PROTECT, related_name="items")
    product = models.ForeignKey(
        Product,
        on_delete=models.PROTECT,
    )
    quantity = models.PositiveSmallIntegerField()

    def __str__(self) -> str:
        return self.product.name


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

    def __str__(self) -> str:
        return self.name
