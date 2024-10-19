import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/core/constants/constant.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/ui/onboarding/liquid_card_swipe.dart';
import 'package:marketplace/presentation/ui/onboarding/liquid_swipe_view.dart';
import 'package:marketplace/presentation/widgets/grow_animation.dart';
import 'package:marketplace/presentation/widgets/move_bounce_animation.dart';

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
                id: Constant.blob,
                duration: const Duration(seconds: 4),
                size: 350,
                styles: BlobStyles(
                    fillType: BlobFillType.fill, color: Colors.blue.shade200),
                loop: true,
                child: Transform.scale(
                  scale: .6,
                  child: MoveAndBounceAnimation(
                    child: Image.asset(
                      ImageAsset.cart,
                    ),
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
            buttonColor: ColorManager.white,
            titleColor: ColorManager.white,
            subtitleColor: Colors.blue.shade200,
            bodyColor: ColorManager.white,
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          /// Second page
          LiquidSwipeCard(
            useCustomWidget: true,
            customWidget: Center(
              child: Blob.animatedFromID(
                id: Constant.blob,
                duration: const Duration(seconds: 4),
                size: 350,
                styles: BlobStyles(
                    fillType: BlobFillType.fill, color: ColorManager.black),
                loop: true,
                child: MoveAndBounceAnimation(
                  child: Transform.scale(
                    scale: .9,
                    child: Image.asset(
                      ImageAsset.atm,
                    ),
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
            buttonColor: ColorManager.black,
            titleColor: ColorManager.black,
            subtitleColor: ColorManager.grey,
            bodyColor: ColorManager.black,
            gradient: const LinearGradient(
              colors: [Colors.yellow, Colors.yellow],
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
