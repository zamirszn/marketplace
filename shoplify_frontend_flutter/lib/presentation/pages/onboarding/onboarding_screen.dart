import 'package:flutter/material.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/data/source/shared_pref_service_impl.dart';
import 'package:shoplify/presentation/resources/asset_manager.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/service_locator.dart';
import 'package:shoplify/presentation/pages/onboarding/liquid_card_swipe.dart';
import 'package:shoplify/presentation/pages/onboarding/liquid_swipe_view.dart';
import 'package:shoplify/presentation/widgets/move_bounce_animation.dart';

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
      backgroundColor: ColorManager.lemon,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceHeight(context),
          child: LiquidSwipe(
            key: _key,
            children: [
              /// First page
              LiquidSwipeCard(
                useCustomWidget: true,
                customWidget: Center(
                  child: Transform.scale(
                    scale: .6,
                    child: MoveAndBounceAnimation(
                      child: Image.asset(
                        ImageAsset.cart,
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
                subtitleColor: ColorManager.white,
                bodyColor: ColorManager.black,
                gradient: LinearGradient(
                  colors: [ColorManager.lemon, ColorManager.lemon],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              /// Second page
              LiquidSwipeCard(
                useCustomWidget: true,
                customWidget: Center(
                  child: MoveAndBounceAnimation(
                    child: Transform.scale(
                      scale: .9,
                      child: Image.asset(
                        ImageAsset.paperbag,
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
                buttonColor: ColorManager.black,
                titleColor: ColorManager.white,
                subtitleColor: ColorManager.black,
                bodyColor: ColorManager.darkBlue,
                gradient: LinearGradient(
                  colors: [
                    ColorManager.cyan,
                    ColorManager.cyan,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToNextPage() async {
    goPush(context, Routes.signUpPage);
  }

  void doneOnboarding() async {
    await sl<SharedPrefDataSource>().writeBool(Constant.doneOnboarding, true);
  }
}
