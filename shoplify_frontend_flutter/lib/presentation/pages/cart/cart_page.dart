import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/pages/cart/cart_item_listview.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/dashed_line.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    context.read<CartBloc>().add(GetCartEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: false,
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
          backgroundColor: colorScheme.surface,
          forceMaterialTransparency: true,
          elevation: 0,
          title: Text(
            AppStrings.cart,
            style: getRegularStyle(context,
                font: FontConstants.ojuju, fontSize: FontSize.s20),
          )),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CartBloc>().add(GetCartEvent());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CartItemListview(),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state.status == CartStatus.success &&
                    state.cart?.items != null &&
                    state.cart!.items!.isNotEmpty) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p10),
                    child: Column(
                      children: [
                        space(h: AppSize.s40),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p14),
                          child: Column(
                            children: [
                              // order amount
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.orderAmount,
                                    style: getMediumStyle(context,
                                        fontSize: FontSize.s16),
                                  ),
                                  Text(
                                    "\$ ${roundToTwoDecimalPlaces(state.cart?.cartTotal ?? 0)}",
                                    style: getSemiBoldStyle(context,
                                        fontSize: FontSize.s16),
                                  ),
                                ],
                              ),
                              space(h: AppSize.s18),

                              DashedLine(
                                color: ColorManager.black.withAlpha(50),
                                spacing: 5,
                                strokeThickness: 2,
                                strokeWidth: 5,
                              ),
                              space(h: AppSize.s18),
                              // Tax
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.tax,
                                    style: getMediumStyle(context,
                                        fontSize: FontSize.s16),
                                  ),
                                  Text(
                                    "\$1.00",
                                    style: getSemiBoldStyle(context,
                                        fontSize: FontSize.s16),
                                  ),
                                ],
                              ),
                              space(h: AppSize.s18),

                              DashedLine(
                                color: ColorManager.black.withAlpha(50),
                                spacing: 5,
                                strokeThickness: 2,
                                strokeWidth: 5,
                              ),
                              space(h: AppSize.s18),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.totalPayment,
                                    style: getMediumStyle(context,
                                        fontSize: FontSize.s16),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "(${state.cart?.items?.length} items)",
                                        style: getRegularStyle(context,
                                            fontSize: FontSize.s12),
                                      ),
                                      space(w: AppSize.s10),
                                      Text(
                                        "\$ ${roundToTwoDecimalPlaces(state.cart?.cartTotal ?? 0)}",
                                        style: getSemiBoldStyle(context,
                                            fontSize: FontSize.s16),
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
                                    onPressed: () {
                                      goPush(context, Routes.orderPage);
                                    },
                                    child: const Text(
                                        AppStrings.proceedToCheckOut)),
                              )
                            ],
                          ),
                        ),
                        space(h: AppSize.s100),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
