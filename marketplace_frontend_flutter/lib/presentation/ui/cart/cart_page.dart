import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/ui/cart/cart_item_listview.dart';
import 'package:marketplace/presentation/widgets/back_button.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            AppStrings.cart,
            style: getRegularStyle(
                font: FontConstants.ojuju, fontSize: FontSize.s20),
          )),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: CartItemListview(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p7),
            sliver: SliverToBoxAdapter(
                child: TextField(
              decoration: InputDecoration(
                  hintText: AppStrings.promoCode,
                  hintStyle:
                      getMediumStyle(color: ColorManager.black.withOpacity(.6)),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p2, horizontal: AppPadding.p5),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          shadowColor: Colors.transparent,
                          backgroundColor: ColorManager.color6.withOpacity(.3),
                        ),
                        onPressed: () {},
                        child: Text(AppStrings.apply)),
                  )),
            )),
          ),
          SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p7),
              sliver: SliverToBoxAdapter(
                  child: Column(
                children: [],
              ))),
        ],
      ),
    );
  }
}
