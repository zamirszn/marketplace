from django.urls import path, include
from . import views
from rest_framework_nested import routers


router = routers.DefaultRouter()
router.register("products", views.ProductViewSet)
router.register("categories", views.CategoryViewSet)
router.register("cart", views.CartViewSet)
router.register("profiles", views.ProfileViewSet)
router.register("orders", views.OrderViewSet, basename="orders")
product_router = routers.NestedDefaultRouter(router, "products", lookup="product")
product_router.register("reviews", views.ReviewViewSet, basename="product-reviews")


cart_router = routers.NestedDefaultRouter(router, "cart", lookup="cart")

cart_router.register("items", views.CartItemViewset, basename="cart-items")

urlpatterns = [
    path("", include(router.urls)),
    path("", include(product_router.urls)),
    path("", include(cart_router.urls)),
]
