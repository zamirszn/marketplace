# Generated by Django 5.1 on 2024-11-19 15:55

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('market_place_api', '0011_alter_productimage_image'),
    ]

    operations = [
        migrations.AlterField(
            model_name='productimage',
            name='image',
            field=models.ImageField(blank=True, null=True, upload_to='', verbose_name='product_images'),
        ),
    ]