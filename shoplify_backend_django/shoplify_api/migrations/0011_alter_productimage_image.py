# Generated by Django 5.1 on 2024-11-16 13:13

import cloudinary.models
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("shoplify_api", "0010_alter_review_unique_together"),
    ]

    operations = [
        migrations.AlterField(
            model_name="productimage",
            name="image",
            field=cloudinary.models.CloudinaryField(
                blank=True, max_length=255, null=True, verbose_name="product_images"
            ),
        ),
    ]
