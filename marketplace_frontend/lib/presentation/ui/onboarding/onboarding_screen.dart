import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:marketplace/app/constant.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/presentation/resources/color_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/ui/onboarding/liquid_card_swipe.dart';
import 'package:marketplace/presentation/ui/onboarding/liquid_swipe_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            customWidget: Lottie.asset(LottieAsset.bag),
            onTapName: () => liquidSwipeController?.previous(),
            onSkip: () async {
              goHome();
            },
            name: Constant.appName,
            action: AppStrings.skip,
            image: null,
            title: AppStrings.shop,
            subtitle: AppStrings.discoverGreatDeals,
            body: AppStrings.exploreVast,
            buttonColor: ColorManager.primary,
            titleColor: ColorManager.greyLight,
            subtitleColor: ColorManager.greyDark,
            bodyColor: ColorManager.primary,
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          /// Second page
          LiquidSwipeCard(
            useCustomWidget: true,
            customWidget: Lottie.asset(LottieAsset.money),
            onTapName: () => liquidSwipeController?.previous(),
            onSkip: () async {
              goHome();
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
              colors: [Colors.grey, ColorManager.primary],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ],
      ),
    );
  }

  void goHome() async {
    // navigator.pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => const BottomNav(),
    //   ),
    // );
  }
}
