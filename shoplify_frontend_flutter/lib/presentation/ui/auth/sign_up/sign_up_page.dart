import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:blobs/blobs.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/presentation/ui/auth/sign_up/bloc/signup_bloc.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/signup_params_model.dart';
import 'package:shoplify/presentation/resources/asset_manager.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  // TODO: remove filled data

  final emailController = TextEditingController(
      text: kDebugMode
          ? "testmail${DateTime.now().microsecondsSinceEpoch}@gmail.com"
          : null);
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
            if (state is SignUpSuccessState) {
              showMessage(context, AppStrings.signUpSuccessful);
              goPush(context, Routes.accountVerificationPage);
            } else if (state is SignUpFailureState) {
              showErrorMessage(context, state.error);
            }
          },
          child: Form(
            key: formKey,
            child: ColoredBox(
              color: ColorManager.primary,
              child: SizedBox(
                height: deviceHeight(context),
                width: deviceWidth(context),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    space(h: AppSize.s50),
                    Center(
                        child: Text(
                      AppStrings.letsGetStarted,
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                          color: ColorManager.black,
                          font: FontConstants.ojuju,
                          fontSize: FontSize.s35),
                    )),
                    Center(
                      child: Blob.animatedFromID(
                        id: Constant.blob,
                        duration: const Duration(seconds: 4),
                        size: 300,
                        styles: BlobStyles(
                            fillType: BlobFillType.fill,
                            color: ColorManager.secondary),
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
                      return ColoredBox(
                        color: ColorManager.primaryDark,
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
                                    color: ColorManager.white,
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
                                        .add(SignUpFullNameChangedEvent(value)),
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
                                              vertical: AppPadding.p14,
                                              horizontal: AppPadding.p5),
                                      focusedBorder: noOutlineInput,
                                      enabledBorder: noOutlineInput,
                                      errorBorder: noOutlineInput,
                                      disabledBorder: noOutlineInput,
                                      focusedErrorBorder: noOutlineInput,
                                      filled: true,
                                      fillColor:
                                          ColorManager.primary.withOpacity(.9),
                                    )),
                              ),
                              space(h: AppSize.s20),
                              Text(
                                AppStrings.emailAddress,
                                style: getSemiBoldStyle(
                                    color: ColorManager.white,
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
                                        .add(EmailChangedEvent(value)),
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
                                              vertical: AppPadding.p14,
                                              horizontal: AppPadding.p5),
                                      focusedBorder: noOutlineInput,
                                      enabledBorder: noOutlineInput,
                                      errorBorder: noOutlineInput,
                                      disabledBorder: noOutlineInput,
                                      focusedErrorBorder: noOutlineInput,
                                      filled: true,
                                      fillColor:
                                          ColorManager.primary.withOpacity(.9),
                                    )),
                              ),
                              //
                              // password
                              space(h: AppSize.s20),
                              Text(
                                AppStrings.password,
                                style: getSemiBoldStyle(
                                    color: ColorManager.white,
                                    font: FontConstants.ojuju,
                                    fontSize: FontSize.s16),
                              ),
                              space(h: AppSize.s10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TextFormField(
                                    onChanged: (value) => context
                                        .read<SignUpBloc>()
                                        .add(SignUpPasswordChangedEvent(value)),
                                    obscureText:
                                        state is SignUpTogglePasswordState
                                            ? state.isPasswordVisible
                                            : false,
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
                                              SignUpPasswordVisibilityEvent(
                                                  isPasswordVisible: state
                                                      is! SignUpTogglePasswordState));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Icon(
                                            (state is SignUpTogglePasswordState &&
                                                    state.isPasswordVisible)
                                                ? Iconsax.eye
                                                : Iconsax.eye_slash,
                                          ),
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: AppPadding.p14,
                                              horizontal: AppPadding.p5),
                                      border: noOutlineInput,
                                      focusedBorder: noOutlineInput,
                                      enabledBorder: noOutlineInput,
                                      errorBorder: noOutlineInput,
                                      disabledBorder: noOutlineInput,
                                      focusedErrorBorder: noOutlineInput,
                                      filled: true,
                                      fillColor:
                                          ColorManager.primary.withOpacity(.9),
                                    )),
                              ),
                              space(h: AppSize.s40),
                              SizedBox(
                                height: AppSize.s50,
                                child: BlocBuilder<SignUpBloc, SignUpState>(
                                  builder: (context, state) {
                                    if (state is SignUpLoadingState) {
                                      return const ButtonLoadingWidget();
                                    }

                                    return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                                ColorManager.primary),
                                        onPressed: () {
                                          if (formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            context
                                                .read<SignUpBloc>()
                                                .add(SignUpSubmittedEvent(
                                                    params: SignupParamsModel(
                                                  fullName:
                                                      fullNameController.text,
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text,
                                                )));
                                          }
                                        },
                                        child: Text(
                                          AppStrings.signUp,
                                          style: getSemiBoldStyle(
                                              color: ColorManager.black),
                                        ));
                                  },
                                ),
                              ),
                              space(h: AppSize.s20),
                              GestureDetector(
                                onTap: () => goto(context, Routes.loginPage),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.alreadyHaveAnAccount,
                                      style: getRegularStyle(
                                          color: ColorManager.primary,
                                          fontSize: FontSize.s14),
                                    ),
                                    space(w: AppSize.s4),
                                    Text(
                                      AppStrings.logIn,
                                      style: getSemiBoldStyle(
                                          fontSize: FontSize.s14,
                                          color: ColorManager.primary),
                                    ),
                                  ],
                                ),
                              ),

                              space(h: AppSize.s40),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                )),
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
            elevation: 0, backgroundColor: ColorManager.secondary),
        onPressed: null,
        child: Transform.scale(scale: .7, child: const LoadingWidget()));
  }
}
