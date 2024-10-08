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
from rest_framework.decorators import action
from rest_framework.views import APIView
import stripe


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


def stripe_card_payment(request):
    stripe.api_key = settings.STRIPE_SECRET_KEY

    data = request.data
    email = data["email"]
    payment_method_id = data["payment_method_id"]
    extra_msg = ""

    customer_data = stripe.Customer.list(email=email).data
    if len(customer_data) == 0:
        customer = stripe.Customer.create(email=email, payment_method=payment_method_id)

    else:
        customer = customer_data[0]
        extra_msg = "Customer already existed."

    try:
        # Create a PaymentIntent
        stripe.PaymentIntent.create(
            customer=customer,
            payment_method=payment_method_id,
            currency="usd",
            amount=1000,
            confirm=True,
        )

        return Response(
            status=status.HTTP_200_OK,
            data={
                "message": "Success",
                "data": {"customer_id": customer.id, "extra_msg": extra_msg},
            },
        )

    except stripe.error.CardError as e:
        return Response(
            status=status.HTTP_400_BAD_REQUEST,
            data={"error": str(e)},
        )
    except stripe.error.RateLimitError as e:
        return Response(
            status=status.HTTP_429_TOO_MANY_REQUESTS,
            data={"error": "Too many requests, please try again later."},
        )
    except stripe.error.InvalidRequestError as e:
        return Response(
            status=status.HTTP_400_BAD_REQUEST,
            data={"error": "Invalid parameters provided."},
        )
    except stripe.error.AuthenticationError as e:
        return Response(
            status=status.HTTP_401_UNAUTHORIZED,
            data={"error": "Authentication with Stripe's API failed."},
        )
    except stripe.error.APIConnectionError as e:
        return Response(
            status=status.HTTP_502_BAD_GATEWAY,
            data={"error": "Network communication with Stripe failed."},
        )
    except stripe.error.StripeError as e:
        return Response(
            status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            data={"error": "An error occurred while processing the payment."},
        )
    except Exception as e:
        return Response(
            status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            data={"error": "An unexpected error occurred"},
        )


def initialize_payment(amount, email, order_id, request):
    card_serializer = CardInformationSerializer(data=request.data)

    if card_serializer.is_valid():
        data_dict = card_serializer.data
        print(data_dict)
        return stripe_card_payment(data_dict=data_dict)
    else:
        # Return a response with the errors
        return Response(
            {"errors": card_serializer.errors}, status=status.HTTP_400_BAD_REQUEST
        )


class OrderViewSet(ModelViewSet):

    @action(detail=True, methods=["POST"])
    def make_payment(self, request, pk=None):
        order = self.get_object()

        for item in order.items.all():
            if item.product.inventory < item.quantity:
                return Response(
                    {"error": f"Insufficient stock for {item.product.name}."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

        amount = order.total_price
        email = request.user.email
        order_id = str(order.id)
        return initialize_payment(amount, email, order_id, request)

    @action(detail=False, methods=["POST"])
    def confirm_payment(self, request):
        order_id = request.GET.get("order_id")
        order = Order.objects.get(id=order_id)
        order.order_status = "C"
        order.save()

        serializer = OrderSerializer(order)

        data = {"message": "Payment successful", "data": serializer.data}
        return Response(data)

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
