import 'dart:ui';

import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/constants/constant.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/widgets/back_button.dart';
import 'package:marketplace/presentation/widgets/move_bounce_animation.dart';
import 'package:marketplace/presentation/widgets/round_icon_text_button.dart';

class LoginOrRegisterPage extends StatelessWidget {
  const LoginOrRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ColoredBox(
        color: ColorManager.primary,
        child: SizedBox(
          height: deviceHeight(context),
          width: deviceWidth(context),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Blob.animatedFromID(
                      id: Constant.blob,
                      duration: const Duration(seconds: 4),
                      size: 350,
                      styles: BlobStyles(
                          fillType: BlobFillType.fill,
                          color: ColorManager.secondary),
                      loop: true,
                      child: Transform.scale(
                        scale: .5,
                        child: MoveAndBounceAnimation(
                          child: Image.asset(
                            ImageAsset.paperbag,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.shopAnExtensive,
                          style: getSemiBoldStyle(
                              color: ColorManager.secondaryDark,
                              font: FontConstants.ojuju,
                              fontSize: FontSize.s30),
                        ),
                        space(h: AppSize.s20),
                        Text(
                          AppStrings.fromTheLatest,
                          style: getRegularStyle(
                              fontSize: FontSize.s14,
                              color: ColorManager.secondary,
                              font: FontConstants.poppins),
                        ),
                      ],
                    ),
                  ),
                  space(h: AppSize.s190),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RoundIconTextButton(
                          bgColor: ColorManager.secondaryDark,
                          textColor: ColorManager.white,
                          iconColor: ColorManager.secondaryDark,
                          text: AppStrings.logIn,
                          onPressed: () {
                            goPush(context, Routes.loginPage);
                          },
                          iconData: Iconsax.key,
                        ),
                        RoundIconTextButton(
                          iconAlignment: IconAlignment.end,
                          bgColor: ColorManager.secondaryDark,
                          textColor: ColorManager.white,
                          iconColor: ColorManager.secondaryDark,
                          text: AppStrings.register,
                          onPressed: () {
                            goPush(context, Routes.signUpPage);
                          },
                          iconData: Iconsax.user,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
