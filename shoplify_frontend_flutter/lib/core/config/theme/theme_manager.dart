import 'package:flutter/material.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';

class AppTheme {
  static ThemeData getTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
      ),
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: FontConstants.poppins,
      scaffoldBackgroundColor: colorScheme.surface,
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) => const GoBackButton(
          padding: EdgeInsets.all(AppPadding.p8),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeInPageTransition(),
          TargetPlatform.iOS: FadeInPageTransition(),
          TargetPlatform.linux: FadeInPageTransition(),
          TargetPlatform.windows: FadeInPageTransition(),
        },
      ),
      popupMenuTheme: const PopupMenuThemeData(surfaceTintColor: Colors.white),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all(colorScheme.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: colorScheme.secondary,
        hintStyle: const TextStyle(
          fontSize: FontSize.s16,
        ),
        suffixIconColor: colorScheme.secondary,
        outlineBorder: BorderSide(color: colorScheme.primary),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: AppSize.s1),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s14)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: colorScheme.onSurface.withAlpha(50), width: AppSize.s1),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s14)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: colorScheme.onSurface.withAlpha(50), width: AppSize.s1),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s14)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: AppSize.s1),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s14)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: AppSize.s1),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s14)),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.primary,
        elevation: AppSize.s4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: colorScheme.onPrimary),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: isDark ? colorScheme.surface : ColorManager.lightGrey,
        elevation: AppSize.s4,
      ),
      buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        buttonColor: colorScheme.primary,
      ),
    );
  }
}
