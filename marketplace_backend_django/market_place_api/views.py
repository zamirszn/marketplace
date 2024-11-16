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
import stripe
from django.utils.safestring import mark_safe
from django.utils.translation import gettext_lazy as _
import json
import random
from rest_framework.decorators import api_view
from django.contrib.humanize.templatetags.humanize import intcomma
from rest_framework.pagination import PageNumberPagination


class ProductViewSet(ModelViewSet):
    http_method_names = ["get"]

    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = ProductFilter
    search_fields = [
        "name",
        "description",
    ]
    ordering_fields = [
        "old_price",
        "name",
    ]


@api_view(["GET"])
def new_products(request):
    new_products = Product.objects.all()[:50]
    serializer = ProductSerializer(new_products, many=True)

    return Response(serializer.data)


@api_view(["GET"])
def popular_products(request):
    # Filter for popular products (either discounted or in flash sales) , a total of 50
    popular_products = (
        Product.objects.filter(discount=True)[:25]
        | Product.objects.filter(flash_sales=True)[:25]
    )

    serializer = ProductSerializer(popular_products, many=True)

    return Response(serializer.data)


class CategoryViewSet(ModelViewSet):
    http_method_names = ["get"]

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

    def get_permissions(self):
        return [IsAuthenticated()]

    def get_queryset(self):
        product_pk = self.kwargs.get("product_pk")
        if product_pk is None:
            raise ValueError("Product primary key is missing.")
        return Review.objects.filter(product_id=product_pk)

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context["product_id"] = self.kwargs.get("product_pk")
        return context


class CartViewSet(ModelViewSet):
    serializer_class = CartSerializer
    permission_classes = [IsAuthenticated]
    http_method_names = ["post", "patch", "delete"]

    def get_queryset(self):
        return Cart.objects.filter(owner=self.request.user)

    def create(self, request, *args, **kwargs):
        user = request.user

        cart = self.get_queryset().first()
        if cart:
            serializer = self.get_serializer(cart)
            return Response(serializer.data, status=status.HTTP_200_OK)

        else:
            # Create a new cart for the user
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            cart = serializer.save(owner=user)

            # Store the cart ID in the user's session
            request.session["cart_id"] = str(cart.id)
            request.session.save()

            headers = self.get_success_headers(serializer.data)
            return Response(
                serializer.data, status=status.HTTP_201_CREATED, headers=headers
            )


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
    # card_serializer = CardInformationSerializer(data=request.data)

    # if card_serializer.is_valid():
    #     data_dict = card_serializer.data
    #     print(data_dict)
    #     return stripe_card_payment(data_dict=data_dict)
    # else:
    #     # Return a response with the errors
    #     return Response(
    #         {"errors": card_serializer.errors}, status=status.HTTP_400_BAD_REQUEST
    #     )
    pass


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


def badge_callback(request):
    return Order.objects.filter(order_status="P").count()


def dashboard_callback(request, context):
    WEEKDAYS = [
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
        "Sun",
    ]

    positive = [[1, random.randrange(8, 28)] for i in range(1, 28)]
    negative = [[-1, -random.randrange(8, 28)] for i in range(1, 28)]
    average = [r[1] - random.randint(3, 5) for r in positive]
    performance_positive = [[1, random.randrange(8, 28)] for i in range(1, 28)]
    performance_negative = [[-1, -random.randrange(8, 28)] for i in range(1, 28)]

    context.update(
        {
            "navigation": [
                {"title": _("Dashboard"), "link": "/", "active": True},
                {"title": _("Analytics"), "link": "#"},
                {"title": _("Settings"), "link": "#"},
            ],
            "filters": [
                {"title": _("All"), "link": "#", "active": True},
                {
                    "title": _("New"),
                    "link": "#",
                },
            ],
            # "kpi": [
            #     {
            #         "title": "Product A Performance",
            #         # "metric": f"${intcomma(f"{random.uniform(1000, 9999):.02f}")}",
            #         "footer": mark_safe(
            #             f'<strong class="text-green-700 font-semibold dark:text-green-400">+{intcomma(f"{random.uniform(1, 9):.02f}")}%</strong>&nbsp;progress from last week'
            #         ),
            #         "chart": json.dumps(
            #             {
            #                 "labels": [WEEKDAYS[day % 7] for day in range(1, 28)],
            #                 "datasets": [{"data": average, "borderColor": "#9333ea"}],
            #             }
            #         ),
            #     },
            #     {
            #         "title": "Product B Performance",
            #         "metric": f"${intcomma(f"{random.uniform(1000, 9999):.02f}")}",
            #         "footer": mark_safe(
            #             f'<strong class="text-green-700 font-semibold dark:text-green-400">+{intcomma(f"{random.uniform(1, 9):.02f}")}%</strong>&nbsp;progress from last week'
            #         ),
            #     },
            #     {
            #         "title": "Product C Performance",
            #         "metric": f"${intcomma(f"{random.uniform(1000, 9999):.02f}")}",
            #         "footer": mark_safe(
            #             f'<strong class="text-green-700 font-semibold dark:text-green-400">+{intcomma(f"{random.uniform(1, 9):.02f}")}%</strong>&nbsp;progress from last week'
            #         ),
            #     },
            # ],
            # "progress": [
            #     {
            #         "title": "🦆 Social marketing e-book",
            #         "description": f"${intcomma(f"{random.uniform(1000, 9999):.02f}")}",
            #         "value": random.randint(10, 90),
            #     },
            #     {
            #         "title": "🦍 Freelancing tasks",
            #         "description": f"${intcomma(f"{random.uniform(1000, 9999):.02f}")}",
            #         "value": random.randint(10, 90),
            #     },
            #     {
            #         "title": "🐋 Development coaching",
            #         "description": f"${intcomma(f"{random.uniform(1000, 9999):.02f}")}",
            #         "value": random.randint(10, 90),
            #     },
            #     {
            #         "title": "🦑 Product consulting",
            #         "description": f"${intcomma(f"{random.uniform(1000, 9999):.02f}")}",
            #         "value": random.randint(10, 90),
            #     },
            #     {
            #         "title": "🐨 Other income",
            #         "description": f"${intcomma(f"{random.uniform(1000, 9999):.02f}")}",
            #         "value": random.randint(10, 90),
            #     },
            #     {
            #         "title": "🐶 Course sales",
            #         "description": f"${intcomma(f"{random.uniform(1000, 9999):.02f}")}",
            #         "value": random.randint(10, 90),
            #     },
            #     {
            #         "title": "🐻‍❄️ Ads revenue",
            #         "description": f"${intcomma(f"{random.uniform(1000, 9999):.02f}")}",
            #         "value": random.randint(10, 90),
            #     },
            # ],
            "chart": json.dumps(
                {
                    "labels": [WEEKDAYS[day % 7] for day in range(1, 28)],
                    "datasets": [
                        {
                            "label": "Example 1",
                            "type": "line",
                            "data": average,
                            "backgroundColor": "#f0abfc",
                            "borderColor": "#f0abfc",
                        },
                        {
                            "label": "Example 2",
                            "data": positive,
                            "backgroundColor": "#9333ea",
                        },
                        {
                            "label": "Example 3",
                            "data": negative,
                            "backgroundColor": "#f43f5e",
                        },
                    ],
                }
            ),
            "performance": [
                {
                    "title": _("Last week revenue"),
                    "metric": "$1,234.56",
                    "footer": mark_safe(
                        '<strong class="text-green-600 font-medium">+3.14%</strong>&nbsp;progress from last week'
                    ),
                    "chart": json.dumps(
                        {
                            "labels": [WEEKDAYS[day % 7] for day in range(1, 28)],
                            "datasets": [
                                {"data": performance_positive, "borderColor": "#9333ea"}
                            ],
                        }
                    ),
                },
                {
                    "title": _("Last week expenses"),
                    "metric": "$1,234.56",
                    "footer": mark_safe(
                        '<strong class="text-green-600 font-medium">+3.14%</strong>&nbsp;progress from last week'
                    ),
                    "chart": json.dumps(
                        {
                            "labels": [WEEKDAYS[day % 7] for day in range(1, 28)],
                            "datasets": [
                                {"data": performance_negative, "borderColor": "#f43f5e"}
                            ],
                        }
                    ),
                },
            ],
        },
    )

    return context
