import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/favorite_product_params_model.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/pages/cart/cart_page.dart';
import 'package:shoplify/presentation/pages/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/pages/favorite/favorite_page.dart';
import 'package:shoplify/presentation/pages/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/pages/home/home_page.dart';
import 'package:shoplify/presentation/pages/profile/profile_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
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
                ProfilePage()
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
                destinations: [
                  const NavigationDestination(
                    label: AppStrings.catalog,
                    icon: Icon(Iconsax.shop),
                  ),
                  NavigationDestination(
                    label: AppStrings.cart,
                    icon: BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        return Badge(
                            label: Text("${state.cart?.items?.length ?? 0}"),
                            backgroundColor: ColorManager.darkBlue,
                            textColor: ColorManager.white,
                            textStyle:
                                getRegularStyle(font: FontConstants.ojuju),
                            child: const Icon(Iconsax.shopping_cart));
                      },
                    ),
                  ),
                  const NavigationDestination(
                    label: AppStrings.favorite,
                    icon: Icon(
                      Iconsax.save_2,
                    ),
                  ),
                  const NavigationDestination(
                    label: AppStrings.profile,
                    icon: Icon(Iconsax.user),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
