import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/presentation/resources/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/shared/image_carousel.dart';
import 'package:marketplace/presentation/shared/market_item_widget.dart';
import 'package:marketplace/presentation/shared/popular_products_carousel.dart';
import 'package:marketplace/presentation/ui/home/products_category_list_widget.dart';
import 'package:marketplace/providers/home_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider state = context.watch<HomeProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: AppPadding.p7),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Iconsax.shop,
              size: AppSize.s28,
            ),
          ),
        ),
        centerTitle: false,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Iconsax.search_normal_1)),
          space(w: AppSize.s8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p7),
            sliver: SliverToBoxAdapter(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Products",
                  style: getSemiBoldStyle(
                    font: FontConstants.ojuju,
                    fontSize: AppSize.s24,
                  ),
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Iconsax.setting_4)),
              ],
            )),
          ),
          sliverSpace(h: AppSize.s10),
          ProductsCategoriesListWidget(state: state),
          sliverSpace(h: AppSize.s20),
          const SliverToBoxAdapter(
            child: SizedBox(height: 300, child: PopularProductsCarousel()),
          ),
          sliverSpace(h: AppSize.s20),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p7),
            sliver: SliverToBoxAdapter(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Discover Products",
                  style: getSemiBoldStyle(
                    font: FontConstants.ojuju,
                    fontSize: AppSize.s24,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "View all",
                      style: getLightStyle(
                        font: FontConstants.poppins,
                        fontSize: AppSize.s14,
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ),
          sliverSpace(h: AppSize.s10),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p7),
            sliver: SliverGrid.builder(
              itemCount: testImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.5,
                  crossAxisSpacing: AppSize.s10,
                  mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                return MarketItemWidget(
                  shouldExtractColor: true,
                  productImagePath: testImages[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
