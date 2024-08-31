from market_place_api.filters import *
from .serializers import *
from .models import *

from rest_framework.viewsets import ModelViewSet
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from rest_framework.mixins import (
    CreateModelMixin,
    RetrieveModelMixin,
    DestroyModelMixin,
)
from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status


class ProductViewSet(ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = ProductFilter
    search_fields = [
        "name",
        "description",
    ]
    ordering_fields = ["old_price", "name"]


class CategoryViewSet(ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
    pagination_class = None


class ReviewViewSet(ModelViewSet):
    serializer_class = ReviewSerializer
    filterset_class = ReviewFilter
    filter_backends = [OrderingFilter]
    ordering_fields = [
        "date_created",
    ]

    def get_queryset(self):
        product_pk = self.kwargs.get("product_pk")
        if product_pk is None:
            raise ValueError("Product primary key is missing.")
        return Review.objects.filter(product_id=product_pk)

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context["product_id"] = self.kwargs.get("product_pk")
        return context


class CartViewSet(
    CreateModelMixin, RetrieveModelMixin, GenericViewSet, DestroyModelMixin
):
    serializer_class = CartSerializer
    queryset = Cart.objects.all()


class CartItemViewset(ModelViewSet):

    http_method_names = ["get", "post", "patch", "delete"]

    def get_queryset(self):
        return CartItem.objects.filter(cart_id=self.kwargs["cart_pk"])

    def get_serializer_class(self):
        if self.request.method == "POST":
            return AddCartItemSerializer

        elif self.request.method == "PATCH":
            return UpdateCartItemSerializer

        return CartItemSerializer

    def get_serializer_context(self):
        context = super().get_serializer_context()
        cart_pk = self.kwargs.get("cart_pk")
        if cart_pk:
            context["cart_id"] = cart_pk
        return context


class OrderViewSet(ModelViewSet):

    http_method_names = ["get", "patch", "post", "delete", "options", "head"]

    def get_permissions(self):
        if self.request.method in ["PATCH", "DELETE"]:
            return [IsAdminUser()]
        return [IsAuthenticated()]

    def create(self, request, *args, **kwargs):
        serializer = CreateOrderSerializer(
            data=request.data, context={"user_id": self.request.user.id}
        )
        serializer.is_valid(raise_exception=True)
        order = serializer.save()
        serializer = OrderSerializer(order)
        return Response(serializer.data)

    def get_serializer_class(self):
        if self.request.method == "POST":
            return CreateOrderSerializer
        elif self.request.method == "PATCH":
            return UpdateOrderSerializer
        return OrderSerializer

    def get_queryset(self):
        user = self.request.user
        if user.is_staff:
            return Order.objects.all()

        return Order.objects.filter(owner=user)


class ProfileViewSet(ModelViewSet):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    parser_classes = (MultiPartParser, FormParser)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        profile = serializer.save()
        serializer = ProfileSerializer(profile)

        return Response(
            {
                "message": "Profile created successfully",
                "profile": profile,
            },
            status=status.HTTP_201_CREATED,
        )
