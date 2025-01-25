import 'package:flutter/material.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/cart/cart_item_listview.dart';
import 'package:shoplify/presentation/widgets/dashed_line.dart';

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
          sliverSpace(h: AppSize.s10),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
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
                          backgroundColor: ColorManager.secondary,
                        ),
                        onPressed: () {},
                        child: const Text(AppStrings.apply)),
                  )),
            )),
          ),
          sliverSpace(h: AppSize.s40),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p14),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  // order amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.orderAmount,
                        style: getMediumStyle(fontSize: FontSize.s16),
                      ),
                      Text(
                        "\$39.00",
                        style: getSemiBoldStyle(fontSize: FontSize.s16),
                      ),
                    ],
                  ),
                  space(h: AppSize.s18),

                  DashedLine(
                    color: ColorManager.black.withOpacity(.06),
                    spacing: 5,
                    strokeThickness: 2,
                    strokeWidth: 5,
                  ),
                  space(h: AppSize.s18),
                  // Tax
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.tax,
                        style: getMediumStyle(fontSize: FontSize.s16),
                      ),
                      Text(
                        "\$1.00",
                        style: getSemiBoldStyle(fontSize: FontSize.s16),
                      ),
                    ],
                  ),
                  space(h: AppSize.s18),

                  DashedLine(
                    color: ColorManager.black.withOpacity(.06),
                    spacing: 5,
                    strokeThickness: 2,
                    strokeWidth: 5,
                  ),
                  space(h: AppSize.s18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.totalPayment,
                        style: getMediumStyle(fontSize: FontSize.s16),
                      ),
                      Row(
                        children: [
                          Text(
                            "(3 items)",
                            style: getRegularStyle(fontSize: FontSize.s12),
                          ),
                          space(w: AppSize.s10),
                          Text(
                            "\$40.00",
                            style: getSemiBoldStyle(fontSize: FontSize.s16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  space(h: AppSize.s40),

                  SizedBox(
                    height: 53,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          shadowColor: Colors.transparent,
                          foregroundColor: ColorManager.black,
                          backgroundColor: ColorManager.secondary,
                        ),
                        onPressed: () {
                          goPush(context, Routes.orderPage);
                        },
                        child: const Text(AppStrings.proceedToCheckOut)),
                  )
                ],
              ),
            ),
          ),
          sliverSpace(h: AppSize.s100),
        ],
      ),
    );
  }
}
