import random
from django.core.management.base import BaseCommand
from market_place_api.models import ProductImage


class Command(BaseCommand):
    help = "Update all ProductImages with random Picsum URLs"

    def handle(self, *args, **kwargs):
        # Fetch all ProductImage objects
        product_images = ProductImage.objects.all()

        # Loop through each ProductImage and update the image URL
        for product_image in product_images:
            # Generate a random image URL
            random_image_url = (
                f"https://picsum.photos/seed/{random.randint(100, 200)}/200/300"
            )

            # Update the image field with the new URL
            product_image.image = random_image_url

            # Save the updated product image
            product_image.save()

            # Print for debugging/verification
            print(
                f"Updated ProductImage {product_image.id} with URL: {random_image_url}"
            )

        self.stdout.write(
            self.style.SUCCESS(
                "Successfully updated all ProductImage entries with random URLs"
            )
        )
