from datetime import datetime
from rest_framework import serializers
from django.db import transaction
from shoplify_api.models import *
from django.contrib.auth import get_user_model

User = get_user_model()


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ["name", "category_id", "slug"]


class ProductImageSerializers(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()

    class Meta:
        model = ProductImage
        fields = ["id", "image", "product"]

    def get_image(self, obj):
        return obj.image.url

class ProductSerializer(serializers.ModelSerializer):
    category = CategorySerializer()
    images = ProductImageSerializers(many=True, read_only=True)
    uploaded_images = serializers.ListField(
        child=serializers.ImageField(
            max_length=4, allow_empty_file=False, use_url=True
        ),
        write_only=True,
    )

    discounted_price = serializers.DecimalField(
    max_digits=10,
    decimal_places=2,
    read_only=True
)

    average_rating = serializers.FloatField(read_only=True)
    reviews_length = serializers.IntegerField(read_only=True)
    is_favorite = serializers.SerializerMethodField()
    

    def get_is_favorite(self, obj):
        """Determines if the product is in the authenticated user's favorites."""
        request = self.context.get("request")
        if request and request.user.is_authenticated:
            return FavoriteProducts.objects.filter(owner=request.user, product=obj).exists()
        return False

    class Meta:
        model = Product
        fields = [
            "id",
            "name",
            "description",
            "category",
            "price",                # base/original price
            "discounted_price",     # computed price after discount
            "slug",
            "inventory",
            "images",
            "uploaded_images",
            "average_rating",
            "reviews_length",
            "is_favorite",
        ]

    def create(self, validated_data):
        uploaded_images = validated_data.pop("uploaded_images", [])
        product = Product.objects.create(**validated_data)
        for image in uploaded_images:
            ProductImage.objects.create(product=product, image=image)
        return product


class TrimmedUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id", "full_name"]


class ReviewSerializer(serializers.ModelSerializer):
    owner = TrimmedUserSerializer(read_only=True)

    class Meta:
        model = Review
        fields = ["id", "product", "date_created", "review", "owner", "rating"]
        read_only_fields = ["owner", "date_created"]

    def validate_rating(self, value):
        if value is None:
            value = 0

        return value

    def validate(self, data):
        request = self.context.get("request")
        if (
            request
            and request.user
            and Review.objects.filter(
                owner_id=request.user.id, product=data["product"]
            ).exists()
        ):
            raise serializers.ValidationError("You have already reviewed this product.")

        return data

    def create(self, validated_data):

        validated_data["owner"] = self.context["request"].user
        product_id = self.context["product_id"]
        return Review.objects.create(product_id=product_id, **validated_data)


# class TrimmedProductDetailsSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Product
#         fields = [
#             "id",
#             "name",
#             "price",
#             "inventory",
#             "images",
#         ]


class CartItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer()
    sub_total = serializers.SerializerMethodField()
    

    class Meta:
        model = CartItem
        fields = ["id", "product", "quantity", "sub_total"]

    def get_sub_total(self, cartItem):
       
            return cartItem.quantity * cartItem.product.price


class CartSerializer(serializers.ModelSerializer):
    id = serializers.UUIDField(read_only=True)
    items = CartItemSerializer(many=True, read_only=True)
    cart_total = serializers.SerializerMethodField()

    class Meta:
        model = Cart
        fields = ["id", "items", "cart_total"]

    def get_cart_total(self, cart):
        items = cart.items.all()
        total = sum(item.quantity * item.product.price for item in items)
        return total


class UpdateCartItemSerializer(serializers.ModelSerializer):
    
    def validate_quantity(self, value):
        """
        Validate that the new quantity doesn't exceed inventory
        """
        # Get the cart item instance being updated
        cart_item = self.instance
        if not cart_item:
            raise serializers.ValidationError("Cart item not found.")
        
        # Get the product to check inventory
        product = cart_item.product
        if not product:
            raise serializers.ValidationError("Product not found.")
        
        # Check if requested quantity exceeds inventory
        if value > product.inventory:  # Assuming your Product model has 'inventory' field
            raise serializers.ValidationError(
                f"Cannot set quantity to {value}. "
                f"Only {product.inventory} items available in stock."
            )
        
        return value
    
    class Meta:
        model = CartItem
        fields = ["quantity"]


class AddCartItemSerializer(serializers.ModelSerializer):
    product_id = serializers.UUIDField()
    product = ProductSerializer(read_only=True)

    def validate_product_id(self, value):
        if not Product.objects.filter(pk=value).exists():
            raise serializers.ValidationError("No product with this Id exists.")
        return value
    
    def validate(self, attrs):
        """
        Validate that the total quantity (existing + new) doesn't exceed inventory
        """
        product_id = attrs["product_id"]
        requested_quantity = attrs["quantity"]
        cart_id = self.context["cart_id"]
        
        # Get the product to check inventory
        try:
            product = Product.objects.get(pk=product_id)
        except Product.DoesNotExist:
            raise serializers.ValidationError("Product not found.")
        
        # Check current quantity in cart
        try:
            existing_cart_item = CartItem.objects.get(
                product_id=product_id, 
                cart_id=cart_id
            )
            current_quantity_in_cart = existing_cart_item.quantity
        except CartItem.DoesNotExist:
            current_quantity_in_cart = 0
        
        # Calculate total quantity that would be in cart
        total_quantity = current_quantity_in_cart + requested_quantity
        
        # Validate against inventory
        if total_quantity > product.inventory:  # Change 'inventory' to your actual field name
            available_to_add = product.inventory - current_quantity_in_cart
            raise serializers.ValidationError(
                f"Cannot add {requested_quantity} items. "
                f"Only {available_to_add} more items can be added. "
                f"(You already have {current_quantity_in_cart} in your cart, "
                f"product has {product.inventory} total in stock)"
            )
        
        return attrs

    def save(self, **kwargs):
        product_id = self.validated_data["product_id"]
        quantity = self.validated_data["quantity"]
        cart_id = self.context["cart_id"]

        try:
            cart_item = CartItem.objects.get(product_id=product_id, cart_id=cart_id)
            # The validation already passed, so we can safely add
            cart_item.quantity += quantity
            cart_item.save()
            self.instance = cart_item
        except CartItem.DoesNotExist:
            # For new items, validation already confirmed quantity <= inventory
            self.instance = CartItem.objects.create(
                cart_id=cart_id, **self.validated_data
            )
        return self.instance
    
    

    class Meta:
        model = CartItem
        fields = ["id", "product", "product_id", "quantity"]

class OrderItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer()

    class Meta:
        model = OrderItem
        fields = ["id", "product", "quantity"]

class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    total_price = serializers.ReadOnlyField()
    grand_total = serializers.ReadOnlyField()

    class Meta:
        model = Order
        fields = [
            "id",
            "placed_at",
            "order_status",
            "owner",
            "phone_number",
            "notes",
            "shipping_cost",
            "total_price",
            "grand_total",
            "items",
        ]


class CreateOrderSerializer(serializers.Serializer):
    cart_id = serializers.UUIDField()
    notes = serializers.CharField(required=False, allow_blank=True)

    def validate_cart_id(self, cart_id):
        if not Cart.objects.filter(pk=cart_id).exists():
            raise serializers.ValidationError("This cart_id is invalid.")
        elif not CartItem.objects.filter(cart_id=cart_id).exists():
            raise serializers.ValidationError("Your cart is empty.")
        return cart_id

    def save(self, **kwargs):
        with transaction.atomic():
            cart_id = self.validated_data["cart_id"]
            user_id = self.context["user_id"]

            user = User.objects.get(pk=user_id)

            order = Order.objects.create(
                owner_id=user_id,
                phone_number=user.profile.phone_number,  # snapshot phone at order time
                notes=self.validated_data.get("notes", ""),
            )

            cart_items = CartItem.objects.filter(cart_id=cart_id)

            order_items = [
                OrderItem(order=order, product=item.product, quantity=item.quantity)
                for item in cart_items
            ]

            OrderItem.objects.bulk_create(order_items)
            # Clear cart items instead of deleting cart
            cart_items.delete()

        return order


class UpdateOrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = ["order_status"]


class FavoriteProductSerializer(serializers.ModelSerializer):
    product = ProductSerializer()
    class Meta:
        model= FavoriteProducts
        fields = ["id", "product",  "created_at", "owner"]
        read_only_fields = ["id", "created_at"]


  
