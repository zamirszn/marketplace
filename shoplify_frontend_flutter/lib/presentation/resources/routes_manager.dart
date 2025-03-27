import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shoplify/data/models/review_param_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/pages/auth/account_blocked.dart';
import 'package:shoplify/presentation/pages/auth/account_verification/account_verification_page.dart';
import 'package:shoplify/presentation/pages/auth/forgot_password/forgot_password_page.dart';
import 'package:shoplify/presentation/pages/auth/forgot_password/new_password_page.dart';
import 'package:shoplify/presentation/pages/auth/splash_page.dart';
import 'package:shoplify/presentation/pages/bottom_nav/bottom_nav.dart';
import 'package:shoplify/presentation/pages/home/product_details/product_details_page.dart';
import 'package:shoplify/presentation/pages/home/product_image_page.dart';
import 'package:shoplify/presentation/pages/notification/notification_page.dart';
import 'package:shoplify/presentation/pages/order/order_page.dart';
import 'package:shoplify/presentation/pages/profile/edit_profile_page.dart';
import 'package:shoplify/presentation/pages/review/add_review_page.dart';
import 'package:shoplify/presentation/pages/review/bloc/review_bloc.dart';
import 'package:shoplify/presentation/pages/review/review_page.dart';
import 'package:shoplify/presentation/pages/search/search_page.dart';
import 'package:shoplify/presentation/widgets/error_404_page.dart';
import 'package:shoplify/presentation/pages/auth/login/login_page.dart';
import 'package:shoplify/presentation/pages/auth/sign_up/sign_up_page.dart';
import 'package:shoplify/presentation/pages/onboarding/onboarding_screen.dart';

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
      path: Routes.loginPage,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.signUpPage,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: Routes.accountVerificationPage,
      builder: (context, state) => const AccountVerificationPage(),
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
      path: Routes.accountBlocked,
      // TODO: work on this page
      builder: (context, state) => const AccountBlocked(),
    ),
    GoRoute(
      path: Routes.forgotPasswordPage,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: Routes.newPasswordPage,
      builder: (context, state) {
        final String email = state.extra as String;

        return NewPasswordPage(
          emailToSendOTP: email,
        );
      },
    ),
    GoRoute(
      path: Routes.searchPage,
      builder: (context, state) {
        return const SearchPage();
      },
    ),
    GoRoute(
      path: Routes.editProfilePage,
      builder: (context, state) {
        return const EditProfilePage();
      },
    ),
    GoRoute(
      path: Routes.notificationPage,
      builder: (context, state) {
        return const NotificationPage();
      },
    ),
    GoRoute(
      path: Routes.addReviewPage,
      builder: (context, state) {
        final ProductModelEntity product = state.extra as ProductModelEntity;

        return AddReviewPage(product: product);
      },
    ),
    GoRoute(
      builder: (context, state) {
        final Map<String, dynamic> extraData =
            state.extra as Map<String, dynamic>;
        final String heroTag = extraData['heroTag'];

        return ProductDetailsPage(
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

        return BlocProvider<ReviewBloc>(
            create: (context) => ReviewBloc()
              ..add(GetProductReviewEvent(
                params: ReviewParamModel(productId: product.id!),
              )),
            child: ReviewPage(
              product: product,
            ));
      },
      path: Routes.productReviewPage,
    ),
  ],
  // TODO: work on this page too
  errorBuilder: (context, state) => const Error404Page(),
);

class Routes {
  static const String onboardingPage = "/onboardingPage";
  static const String notificationPage = "/notificationPage";
  static const String newPasswordPage = "/newPasswordPage";
  static const String forgotPasswordPage = "/forgotPasswordPage";
  static const String editProfilePage = "/editProfilePage";
  static const String addReviewPage = "/addReviewPage";
  static const String loginPage = "/loginPage";
  static const String splashPage = "/splashPage";
  static const String orderPage = "/orderPage";
  static const String signUpPage = "/signUpPage";
  static const String bottomNav = "/bottomNav";
  static const String productDetailsPage = "/productDetailsPage";
  static const String productReviewPage = "/productReviewPage";
  static const String productImagePage = "/productImagePage";
  static const String accountVerificationPage = "/accountVerificationPage";
  static const String accountBlocked = "/accountBlocked";
  static const String searchPage = "/searchPage";
}

Future<void> goPush(BuildContext context, String routeName,
    {Object? extra}) async {
  context.push(
    routeName,
    extra: extra,
  );
}

String? getCurrentRoute(BuildContext context) {
  return GoRouter.of(context).state?.fullPath;
}

void goto(BuildContext context, String routeName, {Object? extra}) {
  context.go(routeName, extra: extra);
}

void goPopRoute(
  BuildContext context,
) {
  GoRouter.of(context).pop();
}
