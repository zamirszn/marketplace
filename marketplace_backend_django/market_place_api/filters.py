from django_filters.rest_framework import FilterSet
from .models import Product, Review


class ProductFilter(FilterSet):
    class Meta:
        model = Product
        fields = {"category_id": ["exact"], "old_price": ["gt", "lt"]}


class ReviewFilter(FilterSet):
    class Meta:
        model = Review
        fields = {"date_created": ["gt", "lt"]}
