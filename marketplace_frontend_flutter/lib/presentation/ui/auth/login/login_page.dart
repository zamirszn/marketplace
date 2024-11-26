import 'dart:ui';

import 'package:blobs/blobs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/core/constants/constant.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/data/models/login_params_model.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/ui/auth/login/bloc/login_bloc.dart';
import 'package:marketplace/presentation/ui/auth/sign_up/sign_up_page.dart';
import 'package:marketplace/presentation/widgets/move_bounce_animation.dart';
import 'package:marketplace/presentation/widgets/snackbar.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  // TODO: remove filled data
  final emailController = TextEditingController(
      text: kDebugMode ? "Mubaraklawal52@gmail.com" : null);
  final passwordController =
      TextEditingController(text: kDebugMode ? "StrongPassword52#" : null);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: BlocProvider(
          create: (context) => LoginBloc(),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                goto(context, Routes.bottomNav);
              } else if (state is LoginFailureState) {
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
                          space(h: AppSize.s80),
                          Center(
                              child: Text(
                            AppStrings.helloWelcome,
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
                              size: 320,
                              styles: BlobStyles(
                                  fillType: BlobFillType.fill,
                                  color: ColorManager.secondary),
                              loop: true,
                              child: Transform.scale(
                                scale: .6,
                                child: MoveAndBounceAnimation(
                                  child: Image.asset(
                                    ImageAsset.giftbox,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          space(h: AppSize.s20),
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              return ColoredBox(
                                color: ColorManager.primaryDark,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppPadding.p20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      space(h: AppSize.s40),
                                      Text(
                                        AppStrings.emailAddress,
                                        style: getSemiBoldStyle(
                                            color: ColorManager.primary,
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
                                            autofillHints: const [
                                              AutofillHints.email
                                            ],
                                            onChanged: (value) {
                                              context.read<LoginBloc>().add(
                                                  LoginFullNameChangedEvent(
                                                      value));
                                            },
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  Constant.emailNameLength),
                                            ],
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Iconsax.sms),
                                              border: noOutlineInput,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: AppPadding.p14,
                                                      horizontal:
                                                          AppPadding.p5),
                                              focusedBorder: noOutlineInput,
                                              enabledBorder: noOutlineInput,
                                              errorBorder: noOutlineInput,
                                              disabledBorder: noOutlineInput,
                                              focusedErrorBorder:
                                                  noOutlineInput,
                                              filled: true,
                                              fillColor: ColorManager.primary
                                                  .withOpacity(.9),
                                            )),
                                      ),
                                      //
                                      // password
                                      space(h: AppSize.s20),
                                      Text(
                                        AppStrings.password,
                                        style: getSemiBoldStyle(
                                            color: ColorManager.primary,
                                            font: FontConstants.ojuju,
                                            fontSize: FontSize.s16),
                                      ),
                                      space(h: AppSize.s10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: TextFormField(
                                            obscureText: state
                                                    is LoginTogglePasswordState
                                                ? state.isPasswordVisible
                                                : false,
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
                                                  context.read<LoginBloc>().add(
                                                      LoginPasswordVisibileEvent(
                                                          isPasswordVisible: state
                                                              is! LoginTogglePasswordState));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: Icon(
                                                    (state is LoginTogglePasswordState &&
                                                            state
                                                                .isPasswordVisible)
                                                        ? Iconsax.eye
                                                        : Iconsax.eye_slash,
                                                  ),
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: AppPadding.p14,
                                                      horizontal:
                                                          AppPadding.p5),
                                              border: noOutlineInput,
                                              focusedBorder: noOutlineInput,
                                              enabledBorder: noOutlineInput,
                                              errorBorder: noOutlineInput,
                                              disabledBorder: noOutlineInput,
                                              focusedErrorBorder:
                                                  noOutlineInput,
                                              filled: true,
                                              fillColor: ColorManager.primary
                                                  .withOpacity(.9),
                                            )),
                                      ),
                                      space(h: AppSize.s40),
                                      SizedBox(
                                        height: AppSize.s50,
                                        child:
                                            BlocBuilder<LoginBloc, LoginState>(
                                          builder: (context, state) {
                                            if (state is LoginLoadingState) {
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
                                                        .read<LoginBloc>()
                                                        .add(LoginSubmittedEvent(
                                                            params: LoginParamsModel(
                                                                email:
                                                                    emailController
                                                                        .text
                                                                        .toLowerCase(),
                                                                    // emails are case sensitive
                                                                password:
                                                                    passwordController
                                                                        .text)));
                                                  }
                                                },
                                                child: Text(
                                                  AppStrings.logIn,
                                                  style: getSemiBoldStyle(
                                                      color:
                                                          ColorManager.black),
                                                ));
                                          },
                                        ),
                                      ),
                                      space(h: AppSize.s20),
                                      GestureDetector(
                                        onTap: () =>
                                            goto(context, Routes.signUpPage),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppStrings.needAnAccount,
                                              style: getRegularStyle(
                                                  color: ColorManager.primary,
                                                  fontSize: FontSize.s14),
                                            ),
                                            space(w: AppSize.s4),
                                            Text(
                                              AppStrings.signUp,
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
                            },
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ));
  }
}
