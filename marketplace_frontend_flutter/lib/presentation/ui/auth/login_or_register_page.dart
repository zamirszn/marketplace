import 'dart:ui';

import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/widgets/back_button.dart';

class LoginOrRegisterPage extends StatelessWidget {
  const LoginOrRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(
          color: ColorManager.white,
        ),
        forceMaterialTransparency: true,
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        height: deviceHeight(context),
        width: deviceWidth(context),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
// add a blue and pink gradient color
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorManager.color1,
                    ColorManager.color2,
                    ColorManager.color3,
                    ColorManager.color4,
                  ],
                ),
              ),
              height: deviceHeight(context),
              width: deviceWidth(context),
            ),
            BackdropFilter(
                blendMode: BlendMode.color,
                filter: ImageFilter.blur(
                  sigmaX: 100,
                  sigmaY: 100,
                ),
                child: Container(
                  color: Colors.transparent,
                )),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    space(h: AppSize.s100),
                    Center(
                        child: Text(
                      AppStrings.shopAnExtensive,
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                          color: ColorManager.white,
                          font: FontConstants.ojuju,
                          fontSize: FontSize.s30),
                    )),
                    space(h: AppSize.s20),
                    Center(
                        child: Text(
                      AppStrings.fromTheLatest,
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                          fontSize: FontSize.s14,
                          color: ColorManager.white,
                          font: FontConstants.poppins),
                    )),
                    Center(
                      child: Blob.animatedFromID(
                        id: const [
                          '7-4-66047',
                          '7-4-32',
                          '7-4-26',
                          '7-4-587933',
                          '7-4-57'
                        ],
                        duration: const Duration(seconds: 4),
                        size: 350,
                        styles: BlobStyles(
                            fillType: BlobFillType.fill,
                            color: Colors.green.shade200),
                        loop: true,
                        child: Transform.scale(
                          scale: .5,
                          child: Image.asset(
                            ImageAsset.megaphone,
                          ),
                        ),
                      ),
                    ),
                    space(h: AppSize.s36),
                    SizedBox(
                      height: AppSize.s50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(elevation: 0),
                            onPressed: () {
                              goPush(context, Routes.loginPage);
                            },
                            child: const Text(AppStrings.logIn)),
                      ),
                    ),
                    space(h: AppSize.s20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p20),
                      child: SizedBox(
                        height: AppSize.s50,
                        child: OutlinedButton(
                            onPressed: () {
                              goPush(context, Routes.signUpPage);
                            },
                            child: const Text(AppStrings.register)),
                      ),
                    ),
                    space(h: AppSize.s20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
