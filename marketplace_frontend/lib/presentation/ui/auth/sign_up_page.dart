import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/constant.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/presentation/resources/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/shared/back_button.dart';
import 'package:marketplace/presentation/ui/auth/sign_up_page.dart';
import 'package:marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider state = context.watch<AuthProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Form(
        key: formKey,
        child: SizedBox(
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
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    space(h: AppSize.s80),
                    Center(
                        child: Text(
                      AppStrings.letsGetStarted,
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                          color: ColorManager.white,
                          font: FontConstants.ojuju,
                          fontSize: FontSize.s35),
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
                        size: 300,
                        styles: BlobStyles(
                            fillType: BlobFillType.fill,
                            color: Colors.cyan.shade100),
                        loop: true,
                        child: Transform.scale(
                          scale: .6,
                          child: Image.asset(
                            ImageAsset.coin,
                          ),
                        ),
                      ),
                    ),
                    space(h: AppSize.s20),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppSize.s20),
                          topRight: Radius.circular(AppSize.s20)),
                      child: ColoredBox(
                        color: ColorManager.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              space(h: AppSize.s40),
                              Text(
                                AppStrings.fullName,
                                style: getSemiBoldStyle(
                                    color: ColorManager.black,
                                    font: FontConstants.ojuju,
                                    fontSize: FontSize.s16),
                              ),
                              space(h: AppSize.s10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TextFormField(
                                    validator: (value) {
                                      return nameValidator(value);
                                    },
                                    controller: fullNameController,
                                    autofillHints: const [AutofillHints.name],
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          Constant.nameLength),
                                    ],
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Iconsax.user),
                                      border: noOutlineInput,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: AppPadding.p14),
                                      focusedBorder: noOutlineInput,
                                      enabledBorder: noOutlineInput,
                                      errorBorder: noOutlineInput,
                                      disabledBorder: noOutlineInput,
                                      focusedErrorBorder: noOutlineInput,
                                      filled: true,
                                      fillColor: Colors.blue.withOpacity(.1),
                                    )),
                              ),
                              space(h: AppSize.s20),
                              Text(
                                AppStrings.emailAddress,
                                style: getSemiBoldStyle(
                                    color: ColorManager.black,
                                    font: FontConstants.ojuju,
                                    fontSize: FontSize.s16),
                              ),
                              space(h: AppSize.s10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TextFormField(
                                    validator: (value) {
                                      return emailNameValidator(value);
                                    },
                                    controller: emailController,
                                    autofillHints: const [AutofillHints.email],
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          Constant.emailNameLength),
                                    ],
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Iconsax.sms),
                                      border: noOutlineInput,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: AppPadding.p14),
                                      focusedBorder: noOutlineInput,
                                      enabledBorder: noOutlineInput,
                                      errorBorder: noOutlineInput,
                                      disabledBorder: noOutlineInput,
                                      focusedErrorBorder: noOutlineInput,
                                      filled: true,
                                      fillColor: Colors.blue.withOpacity(.1),
                                    )),
                              ),
                              //
                              // password
                              space(h: AppSize.s20),
                              Text(
                                AppStrings.password,
                                style: getSemiBoldStyle(
                                    color: ColorManager.black,
                                    font: FontConstants.ojuju,
                                    fontSize: FontSize.s16),
                              ),
                              space(h: AppSize.s10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TextFormField(
                                    obscureText: state.isPasswordVisible,
                                    validator: (value) {
                                      return passwordValidator(value);
                                    },
                                    controller: passwordController,
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          Constant.passwordLength),
                                    ],
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Iconsax.lock,
                                      ),
                                      suffix: GestureDetector(
                                        onTap: () {
                                          state.setPasswordVisibility();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Icon(
                                            state.isPasswordVisible
                                                ? Iconsax.eye
                                                : Iconsax.eye_slash,
                                          ),
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: AppPadding.p14),
                                      border: noOutlineInput,
                                      focusedBorder: noOutlineInput,
                                      enabledBorder: noOutlineInput,
                                      errorBorder: noOutlineInput,
                                      disabledBorder: noOutlineInput,
                                      focusedErrorBorder: noOutlineInput,
                                      filled: true,
                                      fillColor: Colors.blue.withOpacity(.1),
                                    )),
                              ),
                              space(h: AppSize.s40),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppPadding.p5),
                                child: SizedBox(
                                  height: AppSize.s50,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: ColorManager.color2),
                                      onPressed: () {
                                        signUp(context, state);
                                      },
                                      child: Text(
                                        AppStrings.signUp,
                                        style: getSemiBoldStyle(
                                            color: ColorManager.white),
                                      )),
                                ),
                              ),
                              space(h: AppSize.s20),
                              GestureDetector(
                                onTap: () => goto(context, Routes.loginPage),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(AppStrings.alreadyHaveAnAccount),
                                    space(w: AppSize.s4),
                                    Text(
                                      AppStrings.logIn,
                                      style: getSemiBoldStyle(
                                          fontSize: FontSize.s14,
                                          color: ColorManager.black),
                                    ),
                                  ],
                                ),
                              ),

                              space(h: AppSize.s40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUp(BuildContext context, AuthProvider state) {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
    }
  }
}
