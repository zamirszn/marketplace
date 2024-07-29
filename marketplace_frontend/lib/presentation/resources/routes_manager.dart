import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/presentation/shared/error_404_page.dart';
import 'package:marketplace/presentation/ui/auth/login_or_register_page.dart';
import 'package:marketplace/presentation/ui/auth/login_page.dart';
import 'package:marketplace/presentation/ui/auth/sign_up_page.dart';
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
  ],
  errorBuilder: (context, state) => const Error404Page(),
);

class Routes {
  static const String onboardingPage = "/onboardingPage";
  static const String loginPage = "/loginPage";
  static const String signUpPage = "/signUpPage";
  static const String loginOrRegisterPage = "/loginOrRegisterPage";
}

void goPush(BuildContext context, String routeName, {Object? extra}) {
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

