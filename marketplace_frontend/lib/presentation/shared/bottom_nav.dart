import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/presentation/resources/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/shared/color_extractor_widget.dart';
import 'package:marketplace/presentation/ui/favorite/favorite_page.dart';
import 'package:marketplace/presentation/ui/home/home_page.dart';
import 'package:marketplace/providers/bottom_nav_provider.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavProvider state = context.watch<BottomNavProvider>();

    return Scaffold(
      body: IndexedStack(
        index: state.currentIndex,
        children: [
          const HomePage(),
          const FavoritePage(),
          Container(),
          const Center(child: Text('Profile')),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: state.currentIndex,
        onDestinationSelected: (index) {
          state.setCurrentIndex(index);
        },
        backgroundColor: ColorManager.white,
        destinations: [
          const NavigationDestination(
            label: "Catalog",
            icon: Icon(Iconsax.shop),
          ),
          NavigationDestination(
            label: "Cart",
            icon: Badge(
                label: const Text("3"),
                backgroundColor: ColorManager.color1,
                textColor: ColorManager.white,
                textStyle: getRegularStyle(font: FontConstants.ojuju),
                child: const Icon(Iconsax.shopping_bag)),
          ),
          const NavigationDestination(
            label: "Favorite",
            icon: Icon(Iconsax.heart),
          ),
          const NavigationDestination(
            label: "Profile",
            icon: Icon(Iconsax.user),
          ),
        ],
      ),
    );
  }
}
