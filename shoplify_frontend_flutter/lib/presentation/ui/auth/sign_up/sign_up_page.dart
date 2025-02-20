import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      TextEditingController(text: kDebugMode ? "Mubarak Lawal" : null);
  final passwordController =
      TextEditingController(text: kDebugMode ? "StrongPassword52#" : null);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final errorStyle =
        getRegularStyle(color: ColorManager.white, fontSize: FontSize.s10);
    final cursorColor = ColorManager.white;
    return Scaffold(
      backgroundColor: ColorManager.red,
      appBar: AppBar(
        toolbarHeight: 0,
        forceMaterialTransparency: true,
      ),
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
              color: ColorManager.red,
              child: SizedBox(
                height: deviceHeight(context),
                width: deviceWidth(context),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    space(h: AppSize.s36),
                    Padding(
                      padding: const EdgeInsets.only(left: AppSize.s20),
                      child: Text(
                        AppStrings.letsGetStarted,
                        textAlign: TextAlign.start,
                        style: getBoldStyle(
                            color: ColorManager.black,
                            font: FontConstants.poppins,
                            fontSize: AppSize.s50),
                      ),
                    ),
                    space(h: AppSize.s36),
                    BlocBuilder<SignUpBloc, SignUpState>(
                        builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSize.s24)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            space(h: AppSize.s20),
                            Text(
                              AppStrings.fullName,
                              style: getSemiBoldStyle(
                                  color: ColorManager.black,
                                  font: FontConstants.poppins,
                                  fontSize: FontSize.s16),
                            ),
                            space(h: AppSize.s10),
                            TextFormField(
                                cursorColor: cursorColor,
                                style: getRegularStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s20),
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
                                  errorStyle: errorStyle,
                                  prefixIcon: Icon(
                                    Iconsax.user,
                                    color: ColorManager.black,
                                  ),
                                  border: outlineInputBorder(
                                      color: ColorManager.black),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: AppPadding.p14,
                                      horizontal: AppPadding.p10),
                                  focusedBorder: outlineInputBorder(
                                      color: ColorManager.black),
                                  enabledBorder: outlineInputBorder(
                                      color: ColorManager.black),
                                  errorBorder: outlineInputBorder(
                                      color: ColorManager.white),
                                  disabledBorder: outlineInputBorder(
                                      color: ColorManager.black),
                                  focusedErrorBorder: outlineInputBorder(
                                      color: ColorManager.white),
                                )),
                            space(h: AppSize.s20),
                            Text(
                              AppStrings.emailAddress,
                              style: getSemiBoldStyle(
                                  color: ColorManager.black,
                                  font: FontConstants.poppins,
                                  fontSize: FontSize.s16),
                            ),
                            space(h: AppSize.s10),
                            TextFormField(
                                cursorColor: cursorColor,
                                style: getRegularStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s20),
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
                                  errorStyle: errorStyle,
                                  prefixIcon: Icon(
                                    Iconsax.sms,
                                    color: ColorManager.black,
                                  ),
                                  border: outlineInputBorder(
                                      color: ColorManager.black),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: AppPadding.p14,
                                      horizontal: AppPadding.p10),
                                  focusedBorder: outlineInputBorder(
                                      color: ColorManager.black),
                                  enabledBorder: outlineInputBorder(
                                      color: ColorManager.black),
                                  errorBorder: outlineInputBorder(
                                      color: ColorManager.white),
                                  disabledBorder: outlineInputBorder(
                                      color: ColorManager.black),
                                  focusedErrorBorder: outlineInputBorder(
                                      color: ColorManager.white),
                                )),
                            //
                            // password
                            space(h: AppSize.s20),

                            Text(
                              AppStrings.password,
                              style: getSemiBoldStyle(
                                  color: ColorManager.black,
                                  font: FontConstants.poppins,
                                  fontSize: FontSize.s16),
                            ),
                            space(h: AppSize.s10),
                            TextFormField(
                                cursorColor: cursorColor,
                                style: getRegularStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s20),
                                onChanged: (value) => context
                                    .read<SignUpBloc>()
                                    .add(SignUpPasswordChangedEvent(value)),
                                obscureText: state is SignUpTogglePasswordState
                                    ? state.isPasswordVisible
                                    : true,
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
                                  errorStyle: errorStyle,
                                  prefixIcon: Icon(
                                    Iconsax.lock,
                                    color: ColorManager.black,
                                  ),
                                  suffix: GestureDetector(
                                    onTap: () {
                                      context.read<SignUpBloc>().add(
                                          SignUpPasswordVisibilityEvent(
                                              isPasswordVisible: state
                                                      is SignUpTogglePasswordState
                                                  ? state.isPasswordVisible
                                                  : false));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: AppPadding.p10,
                                      ),
                                      child: Icon(
                                        (state is SignUpTogglePasswordState &&
                                                state.isPasswordVisible)
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                        color: ColorManager.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: AppPadding.p14,
                                      horizontal: AppPadding.p5),
                                  border: outlineInputBorder(
                                      color: ColorManager.black),
                                  focusedBorder: outlineInputBorder(
                                      color: ColorManager.black),
                                  enabledBorder: outlineInputBorder(
                                      color: ColorManager.black),
                                  errorBorder: outlineInputBorder(
                                      color: ColorManager.white),
                                  disabledBorder: outlineInputBorder(
                                      color: ColorManager.black),
                                  focusedErrorBorder: outlineInputBorder(
                                      color: ColorManager.white),
                                )),
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
                                          backgroundColor: ColorManager.white),
                                      onPressed: () {
                                        if (formKey.currentState?.validate() ??
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
                                            font: FontConstants.ojuju,
                                            fontSize: FontSize.s20,
                                            color: ColorManager.black),
                                      ));
                                },
                              ),
                            ),
                            space(h: AppSize.s36),

                            GestureDetector(
                              onTap: () => goto(context, Routes.loginPage),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppStrings.alreadyHaveAnAccount,
                                    style: getRegularStyle(
                                        color: ColorManager.black,
                                        fontSize: FontSize.s14),
                                  ),
                                  space(w: AppSize.s4),
                                  Text(
                                    AppStrings.logIn,
                                    style: getSemiBoldStyle(
                                        fontSize: FontSize.s14,
                                        color: ColorManager.white),
                                  ),
                                ],
                              ),
                            ),

                            space(h: AppSize.s20),
                          ],
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
            elevation: 0, backgroundColor: ColorManager.white),
        onPressed: () {},
        child: Transform.scale(scale: .7, child: const LoadingWidget()));
  }
}
