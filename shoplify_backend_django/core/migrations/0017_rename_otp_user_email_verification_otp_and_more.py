# Generated by Django 5.1.4 on 2025-02-25 18:32

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0016_alter_user_otp'),
    ]

    operations = [
        migrations.RenameField(
            model_name='user',
            old_name='otp',
            new_name='email_verification_otp',
        ),
        migrations.RenameField(
            model_name='user',
            old_name='otp_expiry',
            new_name='email_verification_otp_expiry',
        ),
        migrations.AddField(
            model_name='user',
            name='password_reset_expiry',
            field=models.DateTimeField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='user',
            name='password_reset_otp',
            field=models.CharField(blank=True, max_length=4, null=True),
        ),
    ]
