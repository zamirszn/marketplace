# Generated by Django 5.1 on 2024-10-19 07:50

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('market_place_api', '0014_remove_order_payment_status_order_order_status'),
    ]

    operations = [
        migrations.AlterField(
            model_name='profile',
            name='picture',
            field=models.ImageField(blank=True, null=True, upload_to=''),
        ),
    ]
