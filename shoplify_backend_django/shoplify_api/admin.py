from django.contrib import admin
from unfold.admin import StackedInline

from .models import *

from unfold.admin import ModelAdmin
from import_export.admin import ImportExportModelAdmin
from unfold.contrib.import_export.forms import ExportForm, ImportForm, SelectableFieldsExportForm


class ProductImageAdmin(StackedInline):
    model = ProductImage

@admin.register(Product)
class ProductAdmin(ModelAdmin, ImportExportModelAdmin):
    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm
    save_as = True

    list_per_page = 100

    inlines = [ProductImageAdmin]
    list_filter = [
        "discount",
        "created_at",
        "category",
        "flash_sales"
    ]
    list_display = [
        "name",
        "id",
        "discount",
        "price",
        "old_price",
        "average_rating",
        "inventory",
        "reviews_length",
        "created_at",
        "category",
    ]
    search_fields = [
        "name",
        "id",
        
        
        
    ]

    prepopulated_fields = {"slug": ("name",)}

    class Meta:
        model = Product


@admin.register(Category)
class CategoryAdmin(ModelAdmin, ImportExportModelAdmin):
    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm
    save_as = True
    prepopulated_fields = {"slug": ("name",)}
    list_filter = [
        "name",
    ]
    list_display = [
        "name",
    ]
    search_fields = [
        "name",
    ]

    class Meta:
        model = Category

@admin.register(FavoriteProducts)
class FavoriteProductsAdmin(ModelAdmin, ImportExportModelAdmin):

    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm

    list_display= ["owner", "product", "created_at"]

    class Meta:
        model = FavoriteProducts


@admin.register(ProductImage)
class ProductImageAdmin(ModelAdmin, ImportExportModelAdmin):

    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm

    class Meta:
        model = ProductImage

    list_display = ["id", "image", "product"]

    list_per_page = 100


@admin.register(Cart)
class CartAdmin(ModelAdmin, ImportExportModelAdmin):

    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm

    class Meta:
        model = Cart

    list_filter = ["created_at"]
    search_fields = ["created_at", "id"]
    list_display = [
        "id",
        "owner",
        "created_at",

    ]

    list_per_page = 100


@admin.register(CartItem)
class CartItemAdmin(ModelAdmin, ImportExportModelAdmin):

    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm

    class Meta:
        models = CartItem

    search_fields = ["quantity",]
    list_filter = [ "cart",  "product", "quantity",]
    list_display = ["id", "cart",  "product", "quantity", ]

    list_per_page = 100


@admin.register(Order)
class OrderAdmin(ModelAdmin, ImportExportModelAdmin):

    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm

    class Meta:
        models = Order

    list_filter = ["placed_at", "order_status"]
    search_fields = ["id", "placed_at", "order_status"]
    list_display = ["id", "placed_at", "order_status", "owner", "owner_id"]

    list_per_page = 100


@admin.register(Review)
class ReviewAdmin(ModelAdmin, ImportExportModelAdmin):

    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm

    class Meta:
        models = Review

    list_filter = [
        "date_created",
        "rating",
    ]
    search_fields = [
        "id",
        "date_created",
        "review",
    ]
    list_display = [
        "id",
        "product",
        "review",
        "date_created",
        "rating",
    ]

    list_per_page = 100


@admin.register(OrderItem)
class OrderItemAdmin(ModelAdmin, ImportExportModelAdmin):

    import_form_class = ImportForm
    export_form_class = ExportForm
    export_form_class = SelectableFieldsExportForm

    class Meta:
        models = OrderItem

    search_fields = [
        "id",

    ]
    list_display = [
        "id",
        "order",
        "product",
        "quantity",
    ]
   

    list_per_page = 100







