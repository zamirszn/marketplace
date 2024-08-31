import 'package:flutter/material.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/presentation/resources/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/shared/3d_flip_widget.dart';
import 'package:marketplace/presentation/shared/color_extractor_widget.dart';
import 'package:marketplace/presentation/shared/favourite_button.dart';
import 'package:marketplace/presentation/shared/interactive_3d_effect.dart';
import 'package:marketplace/presentation/ui/favorite/favorite_page.dart';
import 'package:marketplace/presentation/ui/home/item_details_page.dart';

class MarketItemWidget extends StatefulWidget {
  const MarketItemWidget({
    super.key,
    required this.productImagePath,
    required this.shouldExtractColor,
  });

  final String productImagePath;
  final bool shouldExtractColor;

  @override
  State<MarketItemWidget> createState() => _MarketItemWidgetState();
}

class _MarketItemWidgetState extends State<MarketItemWidget>
    with TickerProviderStateMixin {
  AnimationController? itemAnimationController;

  @override
  void initState() {
    initAnimation();

    super.initState();
  }

  void initAnimation() {
    itemAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    itemAnimationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        gotoNextDetailsPage().then((_) => itemAnimationController?.reset());
      }
    });
  }

  Future gotoNextDetailsPage() async {
    Navigator.of(context).push(FadeRoute(
      builder: (context) => const ItemDetailsPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Interactive3DEffect(
      child: GestureDetector(
        onTap: () {
          // goPush(
          //   context,
          //   Routes.itemDetailsPage,
          // );
        },
        child: Flip3DPage(
          nextPage: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s10),
            child: ColoredBox(
              color: Colors.red,
              child: SizedBox(
                width: deviceWidth(context),
                height: deviceHeight(context),
              ),
            ),
          ),
          currentPage: Stack(
            children: [
              ColorExtractorWidget(
                shouldExtractColor: widget.shouldExtractColor,
                imageString: widget.productImagePath,
              ),
              SizedBox(
                height: deviceHeight(context),
                width: deviceWidth(context) / 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppSize.s10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MegaPhone",
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s17,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$20.99",
                            overflow: TextOverflow.ellipsis,
                            style: getSemiBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s17,
                            ),
                          ),
                          const FavouriteButton(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
