# Generated by Django 5.1 on 2024-11-15 20:30

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("shoplify_api", "0008_alter_review_rating"),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name="review",
            unique_together=set(),
        ),
    ]
