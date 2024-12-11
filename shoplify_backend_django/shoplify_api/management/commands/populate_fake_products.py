import random
import uuid
from django.core.management.base import BaseCommand
from faker import Faker
from shoplify_api.models import Product, Category, ProductImage


class Command(BaseCommand):
    help = "Populate the database with realistic Product data and image URLs"

    def handle(self, *args, **kwargs):
        fake = Faker()

        categories = list(Category.objects.all())  # Ensure categories already exist

        product_names = [
            "Shoes",
            "Dress",
            "Charger",
            "Laptop",
            "Phone",
            "Tablet",
            "Headphones",
            "Bag",
            "Jacket",
            "Watch",
            "Sneakers",
            "Sunglasses",
            "Backpack",
            "T-Shirt",
            "Smartwatch",
            "Camera",
            "Keyboard",
            "Mouse",
            "Monitor",
            "Speaker",
            "Printer",
            "Desk Lamp",
            "Desk Chair",
            "Blender",
            "Coffee Maker",
            "Electric Kettle",
            "Air Purifier",
            "Microwave",
            "Hair Dryer",
            "Electric Toothbrush",
            "Gaming Console",
            "Bookshelf",
            "Bicycle",
            "Skateboard",
            "Yoga Mat",
            "Water Bottle",
            "Travel Mug",
            "Wallet",
            "Hat",
            "Scarf",
            "Gloves",
            "Umbrella",
            "Laptop Stand",
            "Phone Case",
            "Power Bank",
            "Portable Charger",
            "Bluetooth Speaker",
            "Wireless Earbuds",
            "Fitness Tracker",
            "Sofa",
            "Table",
            "Wall Art",
            "Mirror",
        ]

        for _ in range(2):
            name = random.choice(product_names)
            description = fake.text()
            discount = fake.boolean()
            old_price = round(random.uniform(10, 1000), 2)
            category = random.choice(categories) if categories else None
            slug = fake.slug()
            inventory = fake.random_int(min=1, max=100)
            flash_sales = fake.boolean()

            # Create the product
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

            # Add multiple Picsum images to each product
            for image_index in range(3):  # Example: 3 images per product
                # Create a Picsum URL with a seed based on product slug and image index
                image_url = (
                    f"https://picsum.photos/seed/{random.randint(100, 200)}/200/300"
                )
                print(image_url)
                # Create ProductImage entry with URL
                ProductImage.objects.create(
                    image=image_url,
                    product=product,
                )

            print(f"Created product: {product.name}")

        self.stdout.write(
            self.style.SUCCESS(
                "Successfully populated the database with realistic Product data and image URLs"
            )
        )
