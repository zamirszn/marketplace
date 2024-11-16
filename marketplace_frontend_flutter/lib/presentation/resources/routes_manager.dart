import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/core/constants/constant.dart';
import 'package:marketplace/data/source/secure_storage_data_source.dart';
import 'package:marketplace/data/source/shared_pref_service_impl.dart';
import 'package:marketplace/domain/entities/product_entity.dart';
import 'package:marketplace/presentation/service_locator.dart';
import 'package:marketplace/presentation/ui/auth/account_verification/account_verification.dart';
import 'package:marketplace/presentation/ui/auth/splash_page.dart';
import 'package:marketplace/presentation/ui/bottom_nav/bottom_nav.dart';
import 'package:marketplace/presentation/ui/home/product_image_page.dart';
import 'package:marketplace/presentation/ui/order/order_page.dart';
import 'package:marketplace/presentation/ui/review/review_page.dart';
import 'package:marketplace/presentation/widgets/error_404_page.dart';
import 'package:marketplace/presentation/ui/auth/login_or_register_page.dart';
import 'package:marketplace/presentation/ui/auth/login/login_page.dart';
import 'package:marketplace/presentation/ui/auth/sign_up/sign_up_page.dart';
import 'package:marketplace/presentation/ui/home/product_details_page.dart';
import 'package:marketplace/presentation/ui/onboarding/onboarding_screen.dart';

final GoRouter appRouter = GoRouter(
  //TODO: add onboarding and auth check
  initialLocation: Routes.splashPage,
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      path: Routes.splashPage,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.onboardingPage,
      builder: (context, state) => const LiquidSwipeOnboarding(),
      
    ),
    GoRoute(
      path: Routes.loginOrRegisterPage,
      builder: (context, state) => const LoginOrRegisterPage(),
    ),
    GoRoute(
      path: Routes.loginPage,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: Routes.signUpPage,
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      path: Routes.accountVerificationPage,
      builder: (context, state) => const AccountVerification(),
    ),
    GoRoute(
      path: Routes.bottomNav,
      builder: (context, state) => const BottomNav(),
    ),
    GoRoute(
      path: Routes.orderPage,
      builder: (context, state) => const OrderPage(),
    ),
    GoRoute(
      builder: (context, state) {
        final Map<String, dynamic> extraData =
            state.extra as Map<String, dynamic>;
        final ProductModelEntity product = extraData['product'];
        final String heroTag = extraData['heroTag'];

        return ProductDetailsPage(
          product: product,
          heroTag: heroTag,
        );
      },
      path: Routes.productDetailsPage,
    ),
    GoRoute(
      builder: (context, state) {
        final String image = state.extra as String;

        return ProductImagePage(
          imagePath: image,
        );
      },
     
      path: Routes.productImagePage,
    ),
    GoRoute(
      builder: (context, state) {
        final ProductModelEntity product = state.extra as ProductModelEntity;

        return ReviewPage(
          product: product,
        );
      },
     
      path: Routes.productReviewPage,
    ),
  ],
  errorBuilder: (context, state) => const Error404Page(),

);

class Routes {
  static const String onboardingPage = "/onboardingPage";
  static const String loginPage = "/loginPage";
  static const String splashPage = "/splashPage";
  static const String orderPage = "/orderPage";
  static const String signUpPage = "/signUpPage";
  static const String bottomNav = "/bottomNav";
  static const String productDetailsPage = "/productDetailsPage";
  static const String productReviewPage = "/productReviewPage";
  static const String productImagePage = "/productImagePage";
  static const String loginOrRegisterPage = "/loginOrRegisterPage";
  static const String accountVerificationPage = "/accountVerificationPage";
}

Future<void> goPush(BuildContext context, String routeName,
    {Object? extra}) async {
  context.push(
    routeName,
    extra: extra,
  );
}

void goto(BuildContext context, String routeName, {Object? extra}) {
  context.go(routeName, extra: extra);
}

void goPopRoute(
  BuildContext context,
) {
  GoRouter.of(context).pop();
}