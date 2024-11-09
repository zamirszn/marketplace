import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/core/constants/constant.dart';
import 'package:marketplace/data/source/shared_pref_service_impl.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/service_locator.dart';
import 'package:marketplace/presentation/ui/onboarding/liquid_card_swipe.dart';
import 'package:marketplace/presentation/ui/onboarding/liquid_swipe_view.dart';
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
    resetAnimation();
    super.initState();
  }

  

  resetAnimation() async {
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
                    fillType: BlobFillType.fill, color: ColorManager.secondary),
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
            onSkip: () {
              goToNextPage();
              doneOnboarding();
            },
            name: Constant.appName,
            action: AppStrings.skip,
            image: null,
            title: AppStrings.shop,
            subtitle: AppStrings.discoverGreatDeals,
            body: AppStrings.exploreVast,
            buttonColor: ColorManager.black,
            titleColor: ColorManager.black,
            subtitleColor: ColorManager.secondaryDark,
            bodyColor: ColorManager.black,
            gradient: LinearGradient(
              colors: [ColorManager.white, ColorManager.white],
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
                    fillType: BlobFillType.fill, color: ColorManager.secondary),
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
            onSkip: () {
              goToNextPage();
              doneOnboarding();
            },
            name: AppStrings.back,
            action: AppStrings.done,
            image: null,
            title: AppStrings.browse,
            subtitle: AppStrings.exploreAWideSelection,
            body: AppStrings.findExactly,
            buttonColor: ColorManager.secondaryDark,
            titleColor: ColorManager.secondaryDark,
            subtitleColor: ColorManager.black,
            bodyColor: ColorManager.secondaryDark,
            gradient: LinearGradient(
              colors: [
                ColorManager.primary,
                ColorManager.primary,
              ],
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

  void doneOnboarding() async {
    await sl<SharedPrefDataSource>().writeBool(Constant.doneOnboarding, true);
  }
}
