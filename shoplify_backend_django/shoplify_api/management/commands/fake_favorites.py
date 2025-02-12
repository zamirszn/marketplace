import random
from django.core.management.base import BaseCommand
from faker import Faker
from django.contrib.auth import get_user_model
from shoplify_api.models import FavoriteProducts, Product  # Replace with your actual app name

fake = Faker()
User = get_user_model()

class Command(BaseCommand):
    help = "Generate fake favorite products for users"

    def add_arguments(self, parser):
        parser.add_argument('--users', type=int, default=5, help="Number of users to create favorites for")
        parser.add_argument('--favorites', type=int, default=100, help="Number of favorite products per user")

    def handle(self, *args, **kwargs):
        user_count = kwargs['users']
        favorites_per_user = kwargs['favorites']

        products = list(Product.objects.all())
        if not products:
            self.stdout.write(self.style.ERROR("No products available to favorite."))
            return

        users = User.objects.all()
        if not users:
            self.stdout.write(self.style.ERROR("No users found. Create users first."))
            return

        for user in random.sample(list(users), min(user_count, len(users))):
            random_products = random.sample(products, min(favorites_per_user, len(products)))

            for product in random_products:
                _, created = FavoriteProducts.objects.get_or_create(owner=user, product=product)
                if created:
                    self.stdout.write(self.style.SUCCESS(f"Added {product.name} to {user.email}'s favorites"))
                else:
                    self.stdout.write(self.style.WARNING(f"{product.name} was already in {user.email}'s favorites"))

        self.stdout.write(self.style.SUCCESS(f"Fake favorites generated for {user_count} users!"))
