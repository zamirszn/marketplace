from django.contrib import admin

from .models import *


class ProductImageAdmin(admin.StackedInline):
    model = ProductImage


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):

    list_per_page = 100

    inlines = [ProductImageAdmin]
    list_filter = [
        "discount",
        "old_price",
        "created_at",
        "category",
    ]
    list_display = [
        "name",
        "id",
        "discount",
        "price",
        "old_price",
        "created_at",
        "category",
    ]
    search_fields = [
        "id",
        "discount",
        "price",
        "old_price",
        "created_at",
        "category",
        "average_rating",
    ]

    prepopulated_fields = {"slug": ("name",)}

    class Meta:
        model = Product


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    prepopulated_fields = {"slug": ("title",)}
    list_filter = [
        "title",
    ]
    list_display = [
        "title",
    ]
    search_fields = [
        "title",
    ]

    class Meta:
        model = Category


@admin.register(ProductImage)
class ProductImageAdmin(admin.ModelAdmin):
    class Meta:
        model = ProductImage

    list_display = ["id", "image", "product"]

    list_per_page = 100


@admin.register(Cart)
class CartAdmin(admin.ModelAdmin):
    class Meta:
        model = Cart

    list_filter = ["created_at"]
    search_fields = ["created_at", "id"]
    list_display = [
        "id",
        "created_at",
    ]

    list_per_page = 100


@admin.register(CartItem)
class CartItemAdmin(admin.ModelAdmin):
    class Meta:
        models = CartItem

    list_filter = ["quantity"]
    list_display = ["id", "quantity"]

    list_per_page = 100


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    class Meta:
        models = Order

    list_filter = ["placed_at", "order_status"]
    search_fields = ["id", "placed_at", "order_status"]
    list_display = ["id", "placed_at", "order_status", "owner", "owner_id"]

    list_per_page = 100


@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    class Meta:
        models = Review

    list_filter = [
        "date_created",
    ]
    search_fields = [
        "id",
        "date_created",
    ]
    list_display = [
        "product",
        "date_created",
    ]

    list_per_page = 100


@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    class Meta:
        models = OrderItem

    search_fields = [
        "id",
        "quantity",
    ]
    list_display = [
        "id",
        "quantity",
    ]

    list_per_page = 100


@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    class Meta:
        models = Profile

    search_fields = [
        "id",
        "name",
        "bio",
    ]
    list_display = [
        "id",
        "name",
        "bio",
    ]

    list_per_page = 100
