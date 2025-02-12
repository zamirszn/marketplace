from django.urls import path, include
from . import views
from rest_framework_nested import routers



router = routers.DefaultRouter()
router.register("products", views.ProductViewSet)
router.register("categories", views.CategoryViewSet)
router.register("cart", views.CartViewSet, basename="cart")
router.register("orders", views.OrderViewSet, basename="orders")


product_router = routers.NestedDefaultRouter(router, "products", lookup="product")
product_router.register("reviews", views.ReviewViewSet, basename="product-reviews")


cart_router = routers.NestedDefaultRouter(router, "cart", lookup="cart")
cart_router.register("items", views.CartItemViewset, basename="cart-items")
router.register("favorites", views.FavoriteViewSet, basename="favorites")




urlpatterns = [
    path("", include(router.urls)),
    path("", include(product_router.urls)),
    path("", include(cart_router.urls)),
    path("products/popular-products", views.popular_products, name="popular-products"),
    path("products/new-products", views.new_products, name="new-products"),
    path('save-customer-info', views.save_customer_info, name='save-customer-info'),
        path('favorites/', views.ListFavoritesAPIView.as_view(), name='list_favorites'),

    path("favorites/add/<uuid:pk>", views.FavoriteViewSet.as_view({'post': 'add'}), name="add_favorite"),
    path("favorites/remove/<uuid:pk>", views.FavoriteViewSet.as_view({'delete': 'remove'}), name="remove_favorite"),

]
