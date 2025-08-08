import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/data/source/shared_pref_service_impl.dart';
import 'package:shoplify/presentation/pages/onboarding/liquid_card_swipe.dart';
import 'package:shoplify/presentation/pages/onboarding/liquid_swipe_view.dart';
import 'package:shoplify/presentation/resources/asset_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/service_locator.dart';
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: theme.scaffoldBackgroundColor));

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
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
                      child: Image.asset(ImageAsset.cart),
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
                buttonColor: colorScheme.secondary,
                titleColor: colorScheme.secondary,
                subtitleColor: colorScheme.primary,
                bodyColor: colorScheme.onSurface,
                gradient: LinearGradient(
                  colors: [
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor,
                  ],
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
                      child: Image.asset(ImageAsset.paperbag),
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
                buttonColor: colorScheme.onSecondary,
                titleColor: colorScheme.inversePrimary,
                subtitleColor: colorScheme.onSecondary,
                bodyColor: colorScheme.onSecondary,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary,
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
