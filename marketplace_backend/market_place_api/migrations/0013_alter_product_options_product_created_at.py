# Generated by Django 5.1 on 2024-08-28 12:18

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("market_place_api", "0012_alter_profile_picture"),
    ]

    operations = [
        migrations.AlterModelOptions(
            name="product",
            options={"ordering": ["-created_at"]},
        ),
        migrations.AddField(
            model_name="product",
            name="created_at",
            field=models.DateTimeField(
                auto_now_add=True,
                default=datetime.datetime(
                    2024, 8, 28, 12, 18, 37, 556822, tzinfo=datetime.timezone.utc
                ),
            ),
            preserve_default=False,
        ),
    ]
