import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/core/constants/constant.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/ui/onboarding/liquid_card_swipe.dart';
import 'package:marketplace/presentation/ui/onboarding/liquid_swipe_view.dart';

class LiquidSwipeOnboarding extends StatefulWidget {
  const LiquidSwipeOnboarding({super.key});

  @override
  State<LiquidSwipeOnboarding> createState() => _LiquidSwipeOnboardingState();
}

class _LiquidSwipeOnboardingState extends State<LiquidSwipeOnboarding> {
  final _key = GlobalKey<LiquidSwipeState>();

  LiquidSwipeState? get liquidSwipeController => _key.currentState;

  @override
  void initState() {
    resetAnim();
    super.initState();
  }

  resetAnim() async {
    Future.delayed(const Duration(milliseconds: 50)).then(
      (value) => liquidSwipeController?.previous(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidSwipe(
        key: _key,
        children: [
          /// First page
          LiquidSwipeCard(
            useCustomWidget: true,
            customWidget: Center(
              child: Blob.animatedFromID(
                id: const [
                  '7-4-66047',
                  '7-4-32',
                  '7-4-26',
                  '7-4-587933',
                  '7-4-57'
                ],
                duration: const Duration(seconds: 4),
                size: 350,
                styles: BlobStyles(
                    fillType: BlobFillType.fill, color: Colors.blue.shade200),
                loop: true,
                child: Transform.scale(
                  scale: .6,
                  child: Image.asset(
                    ImageAsset.cart,
                  ),
                ),
              ),
            ),
            onTapName: () => liquidSwipeController?.previous(),
            onSkip: () async {
              goToNextPage();
            },
            name: Constant.appName,
            action: AppStrings.skip,
            image: null,
            title: AppStrings.shop,
            subtitle: AppStrings.discoverGreatDeals,
            body: AppStrings.exploreVast,
            buttonColor: ColorManager.color1,
            titleColor: ColorManager.black,
            subtitleColor: ColorManager.color4,
            bodyColor: ColorManager.color2,
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          /// Second page
          LiquidSwipeCard(
            useCustomWidget: true,
            customWidget: Center(
              child: Blob.animatedFromID(
                id: const [
                  '7-4-66047',
                  '7-4-32',
                  '7-4-26',
                  '7-4-587933',
                  '7-4-57'
                ],
                duration: const Duration(seconds: 4),
                size: 350,
                styles: BlobStyles(
                    fillType: BlobFillType.fill, color: Colors.red.shade200),
                loop: true,
                child: Transform.scale(
                  scale: .5,
                  child: Image.asset(
                    ImageAsset.cart2,
                  ),
                ),
              ),
            ),
            onTapName: () => liquidSwipeController?.previous(),
            onSkip: () async {
              goToNextPage();
            },
            name: AppStrings.back,
            action: AppStrings.done,
            image: null,
            title: AppStrings.browse,
            subtitle: AppStrings.exploreAWideSelection,
            body: AppStrings.findExactly,
            buttonColor: Colors.white,
            titleColor: Colors.black,
            subtitleColor: Colors.grey.shade200,
            bodyColor: Colors.white.withOpacity(0.8),
            gradient: LinearGradient(
              colors: [ColorManager.color3, ColorManager.color1],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ],
      ),
    );
  }

  void goToNextPage() async {
    goPush(context, Routes.loginOrRegisterPage);
  }
}
