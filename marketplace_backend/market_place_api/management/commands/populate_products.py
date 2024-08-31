import random
import uuid
from django.core.management.base import BaseCommand
from faker import Faker
from market_place_api.models import Product, Category


class Command(BaseCommand):
    help = "Populate the database with fake Product data"

    def handle(self, *args, **kwargs):
        fake = Faker()

        categories = list(Category.objects.all())  # Assuming categories already exist

        for _ in range(100):
            name = fake.word()
            description = fake.text()
            discount = fake.boolean()
            old_price = round(random.uniform(10.0, 500.0), 2)
            category = random.choice(categories) if categories else None
            slug = fake.slug()
            inventory = fake.random_int(min=1, max=100)
            flash_sales = fake.boolean()

            product = Product.objects.create(
                name=name,
                description=description,
                discount=discount,
                old_price=old_price,
                category=category,
                slug=slug,
                inventory=inventory,
                flash_sales=flash_sales,
            )

            print(f"Created product: {product.name}")

        self.stdout.write(
            self.style.SUCCESS(
                "Successfully populated the database with fake Product data"
            )
        )
