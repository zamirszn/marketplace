import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/presentation/shared/error_404_page.dart';
import 'package:marketplace/presentation/ui/onboarding/onboarding_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.onboardingRoute,
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      path: Routes.onboardingRoute,
      builder: (context, state) => const LiquidSwipeOnboarding(),
    ),
  ],
  errorBuilder: (context, state) => const Error404Page(),
);

class Routes {
  static const String onboardingRoute = "/onboardingRoute";
}
