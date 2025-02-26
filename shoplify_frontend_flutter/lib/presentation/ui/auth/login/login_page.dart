import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/login_params_model.dart';
import 'package:shoplify/presentation/resources/asset_manager.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/auth/login/bloc/login_bloc.dart';
import 'package:shoplify/presentation/ui/auth/sign_up/sign_up_page.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TODO: remove filled data
  final emailController = TextEditingController(
      text: kDebugMode ? "mubaraklawal52@gmail.com" : null);

  final passwordController =
      TextEditingController(text: kDebugMode ? "Zamirszn52#" : null);

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorStyle =
        getRegularStyle(color: ColorManager.white, fontSize: FontSize.s10);
    final cursorColor = ColorManager.white;
    return Scaffold(
        backgroundColor: ColorManager.blue,
        extendBodyBehindAppBar: true,
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            switch (state.logInStatus) {
              case LoginStatus.initial:
                return;
              case LoginStatus.loading:
                return;
              case LoginStatus.success:
                goto(context, Routes.bottomNav);
              case LoginStatus.failure:
                if (state.errorMessage != null) {
                  showErrorMessage(context, state.errorMessage!);
                }
              case LoginStatus.accountBlocked:
                goto(context, Routes.accountBlocked);

              case LoginStatus.unverified:
                goPush(context, Routes.accountVerificationPage);
            }
          },
          child: Form(
            key: formKey,
            child: ColoredBox(
              color: ColorManager.blue,
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
                            AppStrings.helloThereWelcome,
                            textAlign: TextAlign.start,
                            style: getBoldStyle(
                                color: ColorManager.black,
                                font: FontConstants.poppins,
                                fontSize: AppSize.s50),
                          ),
                        ),
                        space(h: AppSize.s36),
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s24)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p2),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
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
                                      controller: emailController,
                                      autofillHints: const [
                                        AutofillHints.email
                                      ],
                                      onChanged: (value) {
                                        context
                                            .read<LoginBloc>()
                                            .add(LoginEmailChangedEvent(value));
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(
                                            Constant.emailNameLength),
                                      ],
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Iconsax.sms,
                                          color: ColorManager.black,
                                        ),
                                        errorStyle: errorStyle,
                                        border: outlineInputBorder(
                                            color: ColorManager.black),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                      obscureText: state.passwordVisibility ==
                                              PasswordVisibility.on
                                          ? false
                                          : true,
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
                                        errorStyle: errorStyle,
                                        prefixIcon: Icon(
                                          Iconsax.lock,
                                          color: ColorManager.black,
                                        ),
                                        suffix: GestureDetector(
                                          onTap: () {
                                            context.read<LoginBloc>().add(
                                                LoginPasswordVisibileEvent(
                                                    isPasswordVisible: state
                                                        .passwordVisibility));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Icon(
                                              state.passwordVisibility ==
                                                      PasswordVisibility.on
                                                  ? Iconsax.eye
                                                  : Iconsax.eye_slash,
                                              color: ColorManager.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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

                                  space(h: AppSize.s20),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () => goPush(
                                          context, Routes.forgotPasswordPage),
                                      child: Text(
                                        AppStrings.forgotPassword,
                                        style: getSemiBoldStyle(
                                            color: ColorManager.white,
                                            fontSize: FontSize.s14),
                                      ),
                                    ),
                                  ),

                                  space(h: AppSize.s28),
                                  SizedBox(
                                    height: AppSize.s50,
                                    child: BlocBuilder<LoginBloc, LoginState>(
                                      builder: (context, state) {
                                        if (state.logInStatus ==
                                            LoginStatus.loading) {
                                          return const ButtonLoadingWidget();
                                        }
                                        return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    ColorManager.white),
                                            onPressed: () {
                                              if (formKey.currentState
                                                      ?.validate() ??
                                                  false) {
                                                context.read<LoginBloc>().add(
                                                    LoginSubmittedEvent(
                                                        params:
                                                            LoginParamsModel(
                                                                email: emailController
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
                                                  font: FontConstants.ojuju,
                                                  fontSize: FontSize.s20,
                                                  color: ColorManager.black),
                                            ));
                                      },
                                    ),
                                  ),
                                  space(h: AppSize.s36),

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
                                              color: ColorManager.black,
                                              fontSize: FontSize.s14),
                                        ),
                                        space(w: AppSize.s4),
                                        Text(
                                          AppStrings.signUp,
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
                          },
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }
}
