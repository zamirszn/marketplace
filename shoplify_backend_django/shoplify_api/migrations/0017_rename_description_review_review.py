# Generated by Django 5.1 on 2024-12-04 10:32

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('shoplify_api', '0016_alter_review_rating'),
    ]

    operations = [
        migrations.RenameField(
            model_name='review',
            old_name='description',
            new_name='review',
        ),
    ]
