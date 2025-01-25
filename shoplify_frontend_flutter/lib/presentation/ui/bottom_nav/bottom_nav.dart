import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'package:shoplify/presentation/ui/cart/cart_page.dart';
import 'package:shoplify/presentation/ui/favorite/favorite_page.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/ui/home/home_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavBloc>(
          create: (context) => BottomNavBloc(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc()..add(CreateorGetCartEvent()),
        ),
      ],
      child:
          BlocBuilder<BottomNavBloc, BottomNavState>(builder: (context, state) {
        return Scaffold(
            extendBody: true,
            body: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: IndexedStack(
                index: state.selectedIndex,
                children: const [
                  HomePage(),
                  CartPage(),
                  FavoritePage(),
                  Center(child: Text('Profile')),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 7, right: 7),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s24),
                child: NavigationBar(
                  elevation: 0,
                  selectedIndex: state.selectedIndex,
                  onDestinationSelected: (index) {
                    context
                        .read<BottomNavBloc>()
                        .add(BottomNavChangedEvent(index: index));
                  },
                  backgroundColor: ColorManager.primary,
                  destinations: [
                    const NavigationDestination(
                      label: "Catalog",
                      icon: Icon(Iconsax.shop),
                    ),
                    NavigationDestination(
                      label: "Cart",
                      icon: Badge(
                          label: const Text("3"),
                          backgroundColor: ColorManager.secondaryDark,
                          textColor: ColorManager.white,
                          textStyle: getRegularStyle(font: FontConstants.ojuju),
                          child: const Icon(Iconsax.shopping_cart)),
                    ),
                    const NavigationDestination(
                      label: "Favorite",
                      icon: Icon(
                        Iconsax.heart,
                      ),
                    ),
                    const NavigationDestination(
                      label: "Profile",
                      icon: Icon(Iconsax.user),
                    ),
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
