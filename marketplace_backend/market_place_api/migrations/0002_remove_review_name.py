# Generated by Django 5.1 on 2024-08-18 15:09

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('market_place_api', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='review',
            name='name',
        ),
    ]
