import random
from faker import Faker
from django.core.management.base import BaseCommand
from market_place_api.models import Product, Review

from django.contrib.auth import get_user_model

User = get_user_model()


class Command(BaseCommand):
    help = "Generate fake reviews for products"

    def add_arguments(self, parser):
        parser.add_argument(
            "--count", type=int, help="Number of reviews to generate", default=100
        )

    def handle(self, *args, **options):
        fake = Faker()
        count = options["count"]
        products = Product.objects.all()
        users = User.objects.all()

        if not products.exists():
            self.stdout.write(self.style.ERROR("No products found in the database."))
            return

        if not users.exists():
            self.stdout.write(self.style.ERROR("No users found in the database."))
            return

        for _ in range(count):
            product = random.choice(products)
            user = random.choice(users)
            description = fake.paragraph(nb_sentences=3)
            rating = round(random.uniform(1, 5), 1)

            # Create the review without checking for duplicates
            Review.objects.create(
                product=product,
                owner=user,
                description=description,
                rating=rating,
            )

        self.stdout.write(self.style.SUCCESS(f"{count} reviews created successfully!"))
