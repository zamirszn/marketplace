import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/presentation/resources/color_manager.dart';

class AddToCartButton extends StatefulWidget {
  const AddToCartButton({super.key});

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool isAddedToCart = false;

  void onFavorite() {
    setState(() {
      isAddedToCart = !isAddedToCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isAddedToCart
        ? IconButton(
            onPressed: onFavorite,
            icon: const Icon(
              Iconsax.bag_25,
            ),
          )
        : IconButton(
            onPressed: onFavorite,
            icon: const Icon(
              Iconsax.bag_2,
            ),
          );
  }
}
