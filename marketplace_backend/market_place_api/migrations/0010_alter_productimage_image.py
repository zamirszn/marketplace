# Generated by Django 5.1 on 2024-08-28 11:32

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("market_place_api", "0009_alter_productimage_image"),
    ]

    operations = [
        migrations.AlterField(
            model_name="productimage",
            name="image",
            field=models.ImageField(
                blank=True, default="", null=True, upload_to="product_images/"
            ),
        ),
    ]
