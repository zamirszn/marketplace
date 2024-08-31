import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/presentation/shared/bottom_nav.dart';
import 'package:marketplace/presentation/shared/error_404_page.dart';
import 'package:marketplace/presentation/ui/auth/login_or_register_page.dart';
import 'package:marketplace/presentation/ui/auth/login_page.dart';
import 'package:marketplace/presentation/ui/auth/sign_up_page.dart';
import 'package:marketplace/presentation/ui/home/item_details_page.dart';
import 'package:marketplace/presentation/ui/onboarding/onboarding_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.onboardingPage,
  debugLogDiagnostics: kDebugMode,
  routes: [
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
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.signUpPage,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: Routes.bottomNav,
      builder: (context, state) => const BottomNav(),
    ),
    GoRoute(
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage<void>(
          child: const ItemDetailsPage(),
          opaque: false,
          transitionDuration: const Duration(seconds: 2),
          reverseTransitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return ScaleTransition(scale: animation, child: child);
          },
        );
      },
      path: Routes.itemDetailsPage,
    ),
  ],
  errorBuilder: (context, state) => const Error404Page(),
);

class Routes {
  static const String onboardingPage = "/onboardingPage";
  static const String loginPage = "/loginPage";
  static const String signUpPage = "/signUpPage";
  static const String bottomNav = "/bottomNav";
  static const String itemDetailsPage = "/itemDetailsPage";
  static const String loginOrRegisterPage = "/loginOrRegisterPage";
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
