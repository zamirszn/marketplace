import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/ui/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'package:marketplace/presentation/ui/favorite/favorite_page.dart';
import 'package:marketplace/presentation/ui/home/home_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child:
          BlocBuilder<BottomNavBloc, BottomNavState>(builder: (context, state) {
        return Scaffold(
            body: IndexedStack(
              index: state.selectedIndex,
              children: [
                const HomePage(),
                const FavoritePage(),
                Container(),
                const Center(child: Text('Profile')),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: state.selectedIndex,
              onDestinationSelected: (index) {
                context
                    .read<BottomNavBloc>()
                    .add(BottomNavChangedEvent(index: index));
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
            ));
      }),
    );
  }
}
