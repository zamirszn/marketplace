import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/presentation/pages/auth/sign_up/bloc/signup_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

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
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        forceMaterialTransparency: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorScheme.primaryContainer,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: colorScheme.primaryContainer,
        ),
      ),
      body: BlocProvider(
        create: (context) => SignUpBloc(),
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            switch (state.signUpStatus) {
              case SignUpStatus.initial:
              case SignUpStatus.loading:
                return;
              case SignUpStatus.success:
                TextInput.finishAutofillContext(shouldSave: true);

                showMessage(context, AppStrings.signUpSuccessful);
                goPush(context, Routes.loginPage);
              case SignUpStatus.failure:
                if (state.errorMessage != null) {
                  showErrorMessage(context, state.errorMessage!);
                }
            }
          },
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  space(h: AppSize.s20),
                  Padding(
                    padding: const EdgeInsets.only(left: AppSize.s20),
                    child: Text(
                      AppStrings.letsGetStarted,
                      textAlign: TextAlign.start,
                      style: getBoldStyle(context,
                          font: FontConstants.poppins, fontSize: AppSize.s50),
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
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              space(h: AppSize.s20),
                              Required(
                                child: Text(
                                  AppStrings.fullName,
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
                                validator: nameValidator,
                                onChanged: (value) => context
                                    .read<SignUpBloc>()
                                    .add(SignUpFullNameChangedEvent(value)),
                                controller: fullNameController,
                                autofillHints: const [AutofillHints.name],
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      Constant.nameLength),
                                ],
                                decoration: const InputDecoration(
                                  hintText: AppStrings.fullName,
                                  prefixIcon: Icon(
                                    Iconsax.user,
                                  ),
                                ),
                              ),
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
                                  validator: emailValidator,
                                  onChanged: (value) => context
                                      .read<SignUpBloc>()
                                      .add(SignUpEmailChangedEvent(value)),
                                  controller: emailController,
                                  autofillHints: const [AutofillHints.email],
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        Constant.emailLength),
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: AppStrings.emailAddress,
                                    prefixIcon: Icon(
                                      Iconsax.sms,
                                    ),
                                  )),
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
                                onChanged: (value) => context
                                    .read<SignUpBloc>()
                                    .add(SignUpPasswordChangedEvent(value)),
                                obscureText: state.passwordVisibility ==
                                        PasswordVisibility.on
                                    ? false
                                    : true,
                                validator: passwordValidator,
                                controller: passwordController,
                                autofillHints: const [
                                  AutofillHints.newPassword
                                ],
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      Constant.passwordLength),
                                ],
                                decoration: InputDecoration(
                                  hintText: AppStrings.password,
                                  hintStyle:
                                      const TextStyle(fontSize: FontSize.s16),
                                  prefixIcon: const Icon(
                                    Iconsax.lock,
                                  ),
                                  suffix: GestureDetector(
                                    onTap: () => context.read<SignUpBloc>().add(
                                        SignUpPasswordVisibilityEvent(
                                            isPasswordVisible:
                                                state.passwordVisibility)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: AppPadding.p10),
                                      child: Icon(
                                        state.passwordVisibility ==
                                                PasswordVisibility.on
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                        color: colorScheme.secondary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              space(h: AppSize.s40),
                              SizedBox(
                                height: AppSize.s50,
                                child: BlocBuilder<SignUpBloc, SignUpState>(
                                  builder: (context, state) {
                                    if (state.signUpStatus ==
                                        SignUpStatus.loading) {
                                      return const ButtonLoadingWidget();
                                    }

                                    return ElevatedButton(
                                     
                                      onPressed: () {
                                        TextInput.finishAutofillContext(
                                            shouldSave: true);

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
                                          context,
                                          font: FontConstants.ojuju,
                                          fontSize: FontSize.s20,
                                        ),
                                      ),
                                    );
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
                                      style: getBoldStyle(context,
                                          color: colorScheme.secondary,
                                          fontSize: FontSize.s16),
                                    ),
                                    space(w: AppSize.s4),
                                    Text(
                                      AppStrings.logIn,
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
        ),
      ),
    );
  }
}

class ButtonLoadingWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Color? color;

  const ButtonLoadingWidget({super.key, this.backgroundColor, this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? colorScheme.onPrimary),
      onPressed: () {},
      child: Transform.scale(
        scale: .7,
        child: LoadingWidget(
          color: color ?? colorScheme.primary,
        ),
      ),
    );
  }
}
