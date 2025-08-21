from decimal import Decimal
from django_filters.rest_framework import FilterSet, NumberFilter, DateFromToRangeFilter, CharFilter
from .models import Category, Order, Product, Review


class ProductFilter(FilterSet):
    category = CharFilter(
        field_name='category__name',
        lookup_expr='iexact'
    )
    

    class Meta:
        model = Product
        fields = {"category_id": ["exact"], "price": ["gt", "lt"],
                "discount": ["exact"],
                "flash_sales": ["exact"],
                "category":["exact"],
                  
                  }



class OrderFilter(FilterSet):

    class Meta:
        model = Order
        fields = ["order_status"]

class ReviewFilter(FilterSet):
    rating = NumberFilter(method="filter_rating_range")
    date_created = DateFromToRangeFilter()
    class Meta:
        model = Review
        fields = ["date_created", "rating"]

    def filter_rating_range(self, queryset, name, value):
        min_rating = Decimal(value)
        max_rating = Decimal(value) + Decimal(0.9)
        return queryset.filter(rating__gte=min_rating, rating__lte=max_rating)
