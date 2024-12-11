import 'package:flutter/material.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

class AppTheme {
  static final ThemeData appTheme = ThemeData(
      navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
              getRegularStyle(font: FontConstants.poppins))),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeInPageTransition(),
          TargetPlatform.iOS: FadeInPageTransition(),
          TargetPlatform.linux: FadeInPageTransition(),
          TargetPlatform.windows: FadeInPageTransition(),
        },
      ),
      scaffoldBackgroundColor: ColorManager.primaryLight,
      popupMenuTheme: const PopupMenuThemeData(surfaceTintColor: Colors.white),
      colorScheme: ColorScheme.fromSeed(seedColor: ColorManager.secondary),
      radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.all(ColorManager.secondary)),
      inputDecorationTheme: InputDecorationTheme(
        // contentPadding: const EdgeInsets.all(AppPadding.p8),
        hintStyle: getRegularStyle(
          color: ColorManager.black,
          fontSize: FontSize.s14,
        ),

//         // label style
        // labelStyle: getMediumStyle(color: ColorManager.textLight,),
//         // error style
        errorStyle: getRegularStyle(color: ColorManager.red),

        outlineBorder: BorderSide(color: ColorManager.secondary),

        border: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.secondary, width: AppSize.s1),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s14))),

//         // enabled border
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorManager.black.withOpacity(.05), width: AppSize.s1),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s14))),

//         // focused border
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorManager.black.withOpacity(.05), width: AppSize.s1),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s14))),

        // error border
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.red, width: AppSize.s1),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s14))),
        // focused error border
        focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.secondary, width: AppSize.s1),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s14))),
      ),
      // main colors of the app
      primaryColor: ColorManager.secondary,
      // primaryColorLight: ColorManager.primaryOpacity70,
      // primaryColorDark: ColorManager.darkPrimary,
      // disabledColor: ColorManager.grey1,
      // ripple color
      // splashColor: ColorManager.primaryOpacity70,
      // will be used incase of disabled button for example
      // card view theme
      fontFamily: FontConstants.poppins,
      cardTheme: CardTheme(
          color: ColorManager.secondary,
          // shadowColor: ColorManager.grey,
          elevation: AppSize.s4),
      // App bar theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: ColorManager.primary,
        elevation: AppSize.s4,

        // shadowColor: ColorManager.primaryOpacity70,
        // titleTextStyle: getRegularStyle(
        //     color: ColorManager.white,

        //      fontSize: FontSize.s16)
        //
      ),
      // Button theme
      buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        // disabledColor: ColorManager.grey1,
        buttonColor: ColorManager.secondary,
        // splashColor: ColorManager.primaryOpacity70,
      ));

  // elevated button theme
  // elevatedButtonTheme: ElevatedButtonThemeData(
  // style: ElevatedButton.styleFrom(
  //     textStyle: getRegularStyle(
  //       color: ColorManager.white,
  //     ),
  //     backgroundColor: ColorManager.primary,
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(AppSize.s12)))),

  // Text theme
  // textTheme: TextTheme(
  //     displayLarge: getSemiBoldStyle(
  //         color: ColorManager.darkGrey, fontSize: FontSize.s16),
  //     displayMedium: getRegularStyle(
  //         color: ColorManager.white, fontSize: FontSize.s16),
  //     displaySmall:
  //         getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s16),
  //     headlineMedium: getRegularStyle(
  //         color: ColorManager.primary, fontSize: FontSize.s14),
  //     titleMedium: getMediumStyle(
  //         color: ColorManager.lightGrey, fontSize: FontSize.s14),
  //     titleSmall: getMediumStyle(
  //         color: ColorManager.primary, fontSize: FontSize.s14),
  //     bodyMedium: getMediumStyle(color: ColorManager.lightGrey),
  //     bodySmall: getRegularStyle(color: ColorManager.grey1),
  //     bodyLarge: getRegularStyle(color: ColorManager.grey)),
  // input decoration theme (text form field)
}
