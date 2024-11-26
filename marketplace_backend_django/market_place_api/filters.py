from decimal import Decimal
from django_filters.rest_framework import FilterSet, NumberFilter, DateFromToRangeFilter
from .models import Product, Review


class ProductFilter(FilterSet):
    class Meta:
        model = Product
        fields = {"category_id": ["exact"], "old_price": ["gt", "lt"]}


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
