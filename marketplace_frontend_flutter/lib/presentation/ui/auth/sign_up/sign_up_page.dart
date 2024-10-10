import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:blobs/blobs.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/presentation/ui/auth/sign_up/bloc/signup_bloc.dart';
import 'package:marketplace/presentation/widgets/loading_widget.dart';
import 'package:marketplace/core/constants/constant.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/data/models/signup_params_model.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/presentation/widgets/snackbar.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final emailController =
      TextEditingController(text: kDebugMode ? "testmail@gmail.com" : null);
  final fullNameController =
      TextEditingController(text: kDebugMode ? "Mubarak Zamir" : null);
  final passwordController =
      TextEditingController(text: kDebugMode ? "StrongPassword52#" : null);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocProvider(
        create: (context) => SignUpBloc(),
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              showMessage(context, AppStrings.signUpSuccessful);
              goPush(context, Routes.emailVerification);
            } else if (state is SignUpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Form(
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
                      decoration:
                          const BoxDecoration(color: Colors.transparent),
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
                      BlocBuilder<SignUpBloc, SignUpState>(
                          builder: (context, state) {
                        return ClipRRect(
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
                                        onChanged: (value) => context
                                            .read<SignUpBloc>()
                                            .add(FullNameChanged(value)),
                                        controller: fullNameController,
                                        autofillHints: const [
                                          AutofillHints.name
                                        ],
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
                                          fillColor:
                                              Colors.blue.withOpacity(.1),
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
                                        onChanged: (value) => context
                                            .read<SignUpBloc>()
                                            .add(EmailChanged(value)),
                                        controller: emailController,
                                        autofillHints: const [
                                          AutofillHints.email
                                        ],
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
                                          fillColor:
                                              Colors.blue.withOpacity(.1),
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
                                        onChanged: (value) => context
                                            .read<SignUpBloc>()
                                            .add(PasswordChanged(value)),
                                        obscureText:
                                            !(state is SignUpTogglePassword &&
                                                state.isPasswordVisible),
                                        validator: (value) {
                                          return passwordValidator(value);
                                        },
                                        controller: passwordController,
                                        autofillHints: const [
                                          AutofillHints.newPassword
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
                                              context.read<SignUpBloc>().add(
                                                  TogglePasswordVisibility(
                                                      isPasswordVisible: !(state
                                                              is SignUpTogglePassword &&
                                                          !state
                                                              .isPasswordVisible)));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Icon(
                                                (state is SignUpTogglePassword &&
                                                        state.isPasswordVisible)
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
                                          fillColor:
                                              Colors.blue.withOpacity(.1),
                                        )),
                                  ),
                                  space(h: AppSize.s40),
                                  SizedBox(
                                    height: AppSize.s50,
                                    child: BlocBuilder<SignUpBloc, SignUpState>(
                                      builder: (context, state) {
                                        if (state is SignUpLoading) {
                                          return const ButtonLoadingWidget();
                                        }

                                        return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    ColorManager.color2),
                                            onPressed: () {
                                              if (formKey.currentState
                                                      ?.validate() ??
                                                  false) {
                                                context
                                                    .read<SignUpBloc>()
                                                    .add(SignUpSubmitted(
                                                        params:
                                                            SignupParamsModel(
                                                      fullName:
                                                          fullNameController
                                                              .text,
                                                      email:
                                                          emailController.text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                    )));
                                              }
                                            },
                                            child: Text(
                                              AppStrings.signUp,
                                              style: getSemiBoldStyle(
                                                  color: ColorManager.white),
                                            ));
                                      },
                                    ),
                                  ),
                                  space(h: AppSize.s20),
                                  GestureDetector(
                                    onTap: () =>
                                        goto(context, Routes.loginPage),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                            AppStrings.alreadyHaveAnAccount),
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
                        );
                      }),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonLoadingWidget extends StatelessWidget {
  const ButtonLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: ColorManager.color2),
        onPressed: null,
        child: const LoadingWidget());
  }
}
