# Generated by Django 5.1 on 2024-11-21 06:46

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('market_place_api', '0014_alter_review_unique_together'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='review',
            unique_together=set(),
        ),
    ]
