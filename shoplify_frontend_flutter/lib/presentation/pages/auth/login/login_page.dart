import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/presentation/pages/auth/login/bloc/login_bloc.dart';
import 'package:shoplify/presentation/pages/auth/sign_up/sign_up_page.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(
    text: kDebugMode ? "mubaraklawal52@gmail.com" : null,
  );

  final passwordController = TextEditingController(
    text: kDebugMode ? "Zamirszn52#" : null,
  );

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
       
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            switch (state.logInStatus) {
              case LoginStatus.initial:
                return;
              case LoginStatus.loading:
                return;
              case LoginStatus.success:
                TextInput.finishAutofillContext(shouldSave: true);
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  space(h: AppSize.s36),
                  Padding(
                    padding: const EdgeInsets.only(left: AppSize.s20),
                    child: Text(
                      AppStrings.helloThereWelcome,
                      style: getBoldStyle(
                        context,
                        font: FontConstants.poppins,
                        fontSize: AppSize.s50,
                      ),
                    ),
                  ),
                  space(h: AppSize.s36),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s24),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p20),
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              space(h: AppSize.s20),
                              Required(
                                child: Text(
                                  AppStrings.emailAddress,
                                  style: getSemiBoldStyle(context,
                                      font: FontConstants.poppins,
                                      fontSize: FontSize.s16),
                                ),
                              ),
                              space(h: AppSize.s10),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: getRegularStyle(context,
                                    fontSize: FontSize.s20),
                                validator: (value) => emailValidator(value),
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                onChanged: (value) => context
                                    .read<LoginBloc>()
                                    .add(LoginEmailChangedEvent(value)),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      Constant.emailLength),
                                ],
                                decoration: const InputDecoration(
                                  hintText: AppStrings.emailAddress,
                                  prefixIcon: Icon(
                                    Iconsax.sms,
                                  ),
                                ),
                              ),
                              space(h: AppSize.s20),
                              Required(
                                child: Text(
                                  AppStrings.password,
                                  style: getSemiBoldStyle(context,
                                      font: FontConstants.poppins,
                                      fontSize: FontSize.s16),
                                ),
                              ),
                              space(h: AppSize.s10),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: getRegularStyle(context,
                                    fontSize: FontSize.s20),
                                obscureText: state.passwordVisibility ==
                                        PasswordVisibility.on
                                    ? false
                                    : true,
                                validator: (value) => passwordValidator(value),
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      Constant.passwordLength),
                                ],
                                decoration: InputDecoration(
                                  hintText: AppStrings.password,
                                  prefixIcon: const Icon(
                                    Iconsax.lock,
                                  ),
                                  suffix: GestureDetector(
                                    onTap: () => context.read<LoginBloc>().add(
                                        LoginPasswordVisibileEvent(
                                            isPasswordVisible:
                                                state.passwordVisibility)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        state.passwordVisibility ==
                                                PasswordVisibility.on
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              space(h: AppSize.s20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () => goPush(
                                      context, Routes.forgotPasswordPage),
                                  child: Text(
                                    AppStrings.forgotPassword,
                                    style: getSemiBoldStyle(context,
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
                                       
                                        onPressed: () {
                                          if (formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            context
                                                .read<LoginBloc>()
                                                .add(LoginSubmittedEvent(
                                                    params: LoginParamsModel(
                                                  email: emailController.text
                                                      .toLowerCase(),
                                                  password:
                                                      passwordController.text,
                                                )));
                                          }
                                        },
                                        child: Text(
                                          AppStrings.logIn,
                                          style: getSemiBoldStyle(
                                            context,
                                            font: FontConstants.ojuju,
                                            fontSize: FontSize.s20,
                                          ),
                                        ));
                                  },
                                ),
                              ),
                              space(h: AppSize.s36),
                              GestureDetector(
                                onTap: () => goto(context, Routes.signUpPage),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.needAnAccount,
                                      style: getBoldStyle(context,
                                          color: colorScheme.secondary,
                                          fontSize: FontSize.s16),
                                    ),
                                    space(w: AppSize.s4),
                                    Text(
                                      AppStrings.signUp,
                                      style: getSemiBoldStyle(
                                        context,
                                        fontSize: FontSize.s16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              space(h: AppSize.s20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
