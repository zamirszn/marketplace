from math import floor
from django.db import models
import uuid
from django.conf import settings
from cloudinary.models import CloudinaryField
from django.core.validators import MinValueValidator, MaxValueValidator
from decimal import Decimal



class Category(models.Model):
    name = models.CharField(max_length=225)
    category_id = models.UUIDField(
        default=uuid.uuid4, editable=False, primary_key=True, unique=True
    )
    slug = models.SlugField(default=None)
    featured_product = models.OneToOneField(
        "Product",
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="featured_product",
    )

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "Category"
        verbose_name_plural = "Categories"


class Review(models.Model):
    product = models.ForeignKey(
        "Product",
        on_delete=models.SET_NULL,
        related_name="reviews",
        null=True,
        default="",
    )

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )

    date_created = models.DateTimeField(
        blank=True,
        null=True,
        auto_now_add=True,
    )
    review = models.TextField(
        blank=False,
        null=True,
    )
    
    rating = models.DecimalField(
    decimal_places=1,
    max_digits=2,
    validators=[MinValueValidator(Decimal('0')), MaxValueValidator(Decimal('5'))],  # Use Decimal instead of int
    null=True,
    blank=True,
    default=Decimal('0'),  # Also use Decimal for default
)

    def save(self, **args):
        if self.rating is not None:
            self.rating = round(self.rating, 1)
            super().save(**args)

    # class Meta:
    #     unique_together = ("product", "owner")

    def __str__(self):
        return f"Review by {self.owner.email} - {self.rating} stars"


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


    
    def __str__(self):
        return self.owner.email + " - cart - " + str(self.created_at)


class Product(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True, null=True)
    discount = models.BooleanField(default=False)
    
    price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        default=0
    )

    # Discount percentage (0 - 100)
    discount_percentage = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0), MaxValueValidator(100)],
        help_text="Enter discount as a percentage (0 - 100)"
    )

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
        default=uuid.uuid4, editable=False, primary_key=True, unique=True)
    
    inventory = models.IntegerField(default=1)
    flash_sales = models.BooleanField(default=False)

    def average_rating(self):
        avg_rating = self.reviews.aggregate(models.Avg("rating"))["rating__avg"]
        return round(avg_rating, 1) if avg_rating is not None else 0

    def reviews_length(self):
        count = self.reviews.count()
        return count
    
    @property
    def discounted_price(self):
        if self.discount_percentage > 0:
            discount_amount = (self.discount_percentage / Decimal("100")) * self.price
            return (self.price - discount_amount).quantize(Decimal("0.01"))
        return None

    

    def __str__(self):
        return self.slug

    class Meta:
        ordering = ["-created_at"]
    
    @property
    def is_favorite(self):
        """Checks if the current product is in the authenticated user's favorites"""
        request = getattr(self, '_request', None)
        if request and request.user.is_authenticated:
            return FavoriteProducts.objects.filter(owner=request.user, product=self).exists()
        return False


class ProductImage(models.Model):

    image = models.ImageField(
        "product_images",
        blank=True,
        null=True,
    )
    # image = CloudinaryField(
    #     "product_images",
    #     blank=True,
    #     null=True,
    # )
    product = models.ForeignKey(
        Product, on_delete=models.SET_NULL, related_name="images",

        blank=True,
        null=True,
    )

    class Meta:
        verbose_name = "Product Image"
        verbose_name_plural = "Products Images"

    
class CartItem(models.Model):
    cart = models.ForeignKey(
        Cart, on_delete=models.SET_NULL, related_name="items", null=True, blank=True
    )
    product = models.ForeignKey(
        Product,
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="cart_items",
    )
    quantity = models.PositiveSmallIntegerField(default=0)

    def __str__(self):
        return str(self.cart.id)

class Order(models.Model):
    class PaymentStatus(models.TextChoices):
        PENDING = "PENDING", "Pending"
        COMPLETE = "COMPLETE", "Complete"
        FAILED = "FAILED", "Failed"

    class OrderStatus(models.TextChoices):
        PENDING = "PENDING", "Pending"
        PROCESSING = "PROCESSING", "Processing"
        SHIPPED = "SHIPPED", "Shipped"
        DELIVERED = "DELIVERED", "Delivered"
        CANCELLED = "CANCELLED", "Cancelled"

    class PaymentMethod(models.TextChoices):
        STRIPE = "STRIPE", "Stripe"
        PAYPAL = "PAYPAL", "PayPal"
        COD = "COD", "Cash on Delivery"


    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="orders"
    )

    placed_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    order_status = models.CharField(
        max_length=20, choices=OrderStatus.choices, default=OrderStatus.PENDING
    )
    payment_status = models.CharField(
        max_length=20, choices=PaymentStatus.choices, default=PaymentStatus.PENDING
    )
    payment_method = models.CharField(
        max_length=20, choices=PaymentMethod.choices, default=PaymentMethod.STRIPE
    )
    transaction_id = models.CharField(
        max_length=100, blank=True, null=True, help_text="Payment gateway reference (Stripe PI, PayPal ID, etc.)"
    )
    paid_at = models.DateTimeField(blank=True, null=True)

    # Snapshot of phone number at checkout
    phone_number = models.CharField(max_length=20, blank=True, null=True)

    # Optional customer notes for special instructions
    notes = models.TextField(blank=True, null=True)

    # Shipping fields
    shipping_address = models.TextField(blank=True, null=True)
    shipping_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    delivered_at = models.DateTimeField(blank=True, null=True)

   
    @property
    def total_price(self):
        total = Decimal("0.00")
        for item in self.items.all():
            total += Decimal(str(item.product.price)) * item.quantity
        return total.quantize(Decimal("0.01"))

    @property
    def grand_total(self):
        return (self.total_price + self.shipping_cost).quantize(Decimal("0.01"))


    def __str__(self):
        return f"Order {self.id} - {self.owner.email if self.owner else 'Guest'}"


class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.SET_NULL, related_name="items", blank=True,
        null=True,)
    product = models.ForeignKey(
        Product,
        on_delete=models.PROTECT,
    )
    quantity = models.PositiveSmallIntegerField()

    def __str__(self) -> str:
        return self.product.name
    

class FavoriteProducts(models.Model):
    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, blank=True, null=True,
        related_name="favorites"
    )
    product = models.ForeignKey(Product, on_delete=models.SET_NULL, related_name="favorited_by", blank=True,
        null=True,)
    created_at = models.DateTimeField(auto_now_add=True,    blank=True,
        null=True,)

    class Meta:
        unique_together = ("owner", "product")

    class Meta:
        verbose_name = "Favorite Products"
        verbose_name_plural = "Favorite Products"

   
    
