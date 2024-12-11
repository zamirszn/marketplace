import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({super.key});

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  bool isFavourite = false;

  void onFavorite() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isFavourite
        ? IconButton(
            onPressed: onFavorite,
            icon: Icon(
              Iconsax.heart5,
              color: ColorManager.red,
            ),
          )
        : IconButton(
            onPressed: onFavorite,
            icon: const Icon(
              Iconsax.heart,
            ),
          );
  }
}
