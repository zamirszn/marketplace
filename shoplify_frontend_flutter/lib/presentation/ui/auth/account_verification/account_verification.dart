
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/presentation/resources/asset_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/move_bounce_animation.dart';
import 'package:pinput/pinput.dart';

class AccountVerification extends StatelessWidget {
  const AccountVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ColoredBox(
        color: Colors.green,
        child: SizedBox(
          height: deviceHeight(context),
          width: deviceWidth(context),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
              child: Column(
                children: [
                  space(h: AppSize.s20),
                  Text(
                    AppStrings.activeYourAccount,
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                        color: ColorManager.black,
                        font: FontConstants.ojuju,
                        fontSize: FontSize.s30),
                  ),
                  space(h: AppSize.s20),
                  Center(
                      child: Text(
                    AppStrings.enterOTPHere,
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.black,
                        font: FontConstants.poppins),
                  )),
                  space(h: AppSize.s20),
                  const FilledInput(),
                  space(h: AppSize.s20),
                  Center(
                    child: Transform.scale(
                      scale: .4,
                      child: MoveAndBounceAnimation(
                        child: Image.asset(
                          ImageAsset.box,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.didntRecieveOTP,
                        textAlign: TextAlign.center,
                        style: getRegularStyle(
                            fontSize: FontSize.s14,
                            color: ColorManager.white,
                            font: FontConstants.poppins),
                      ),
                      space(w: AppSize.s10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ColoredBox(
                          color: const Color.fromRGBO(124, 102, 152, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppStrings.resendCode,
                              textAlign: TextAlign.center,
                              style: getRegularStyle(
                                  fontSize: FontSize.s14,
                                  color: ColorManager.white,
                                  font: FontConstants.poppins),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  space(h: AppSize.s20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: AppSize.s50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: ColorManager.black,
                              ),
                              onPressed: () {
                                goPush(context, Routes.loginPage);
                              },
                              child: Text(
                                AppStrings.continue_,
                                style:
                                    getRegularStyle(color: ColorManager.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                  space(h: AppSize.s20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilledInput extends StatefulWidget {
  const FilledInput({super.key});

  @override
  FilledInputState createState() => FilledInputState();
}

class FilledInputState extends State<FilledInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: getSemiBoldStyle(
          color: ColorManager.white,
          font: FontConstants.ojuju,
          fontSize: FontSize.s20),
      decoration: BoxDecoration(color: ColorManager.black),
    );

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: Pinput(
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.digitsOnly
          ],
          length: 4,
          controller: controller,
          focusNode: focusNode,
          separatorBuilder: (index) => Container(
            height: 64,
            width: 1,
            color: Colors.white,
          ),
          defaultPinTheme: defaultPinTheme,
          showCursor: true,
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(124, 102, 152, 1)),
          ),
        ));
  }
}
