import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/presentation/pages/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:shoplify/presentation/pages/auth/sign_up/sign_up_page.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/count_down_widget/bloc/countdown_bloc.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    super.initState();
  }

  void triggerShake() {
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    emailController.dispose();
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
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state.forgotPasswordStatus == ForgotPasswordStatus.failure) {
            if (state.errorMessage != null) {
              showErrorMessage(context, state.errorMessage!);
            }
          } else if (state.forgotPasswordStatus ==
              ForgotPasswordStatus.success) {
            context.read<CountdownBloc>().add(CountdownStopEvent());
            showMessage(context, AppStrings.passwordChangedSuccessfully);
            goto(context, Routes.loginPage, extra: emailController.text);
          } else if (state.forgotPasswordStatus ==
              ForgotPasswordStatus.otpRequested) {
            goPush(context, Routes.newPasswordPage,
                extra: emailController.text);
          }
        },
        child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.s20,
                  ),
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        space(h: AppSize.s40),
                        const GoBackButton(
                          padding: EdgeInsets.all(AppPadding.p10),
                        ),
                        space(h: AppSize.s40),
                        Text(AppStrings.lostYourPassword,
                            textAlign: TextAlign.start,
                            style: getBoldStyle(context,
                                font: FontConstants.poppins,
                                fontSize: AppSize.s50)),
                        space(h: AppSize.s60),
                        Text(
                          AppStrings.emailAddress,
                          style: getSemiBoldStyle(context,
                              font: FontConstants.poppins,
                              fontSize: FontSize.s16),
                        ),
                        space(h: AppSize.s10),
                        Animate(
                          controller: _animationController,
                          autoPlay: false,
                          effects: [Constant.shakeEffect],
                          child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: getRegularStyle(context,
                                  fontSize: FontSize.s20),
                              validator: (value) => emailValidator(value),
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
                        ),
                        space(h: AppSize.s40),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                minWidth: AppSize.s400,
                                minHeight: AppSize.s50,
                                maxHeight: AppSize.s50,
                                maxWidth: AppSize.s400),
                            child: state.forgotPasswordStatus ==
                                    ForgotPasswordStatus.requestingOTP
                                ? const ButtonLoadingWidget()
                                : ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        context.read<ForgotPasswordBloc>().add(
                                            RequestForgotEvent(
                                                shouldRedirect: true,
                                                email: emailController.text));
                                      } else {
                                        triggerShake();
                                      }
                                    },
                                    child: Text(
                                      AppStrings.continue_,
                                      style: getSemiBoldStyle(
                                        context,
                                        font: FontConstants.ojuju,
                                        fontSize: FontSize.s20,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        space(h: AppSize.s36),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VerifyAccountFilledInput extends StatefulWidget {
  const VerifyAccountFilledInput({super.key});

  @override
  VerifyAccountFilledInputState createState() =>
      VerifyAccountFilledInputState();
}

class VerifyAccountFilledInputState extends State<VerifyAccountFilledInput> {
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
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Pinput(
            scrollPadding: const EdgeInsets.only(bottom: AppSize.s470),
            onChanged: (value) {},
            onCompleted: (value) {},
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
              FilteringTextInputFormatter.digitsOnly,
            ],
            length: 4,
            controller: controller,
            focusNode: focusNode,
            separatorBuilder: (index) => Container(
              height: 64,
              width: 1,
              color: colorScheme.secondaryContainer,
            ),
            defaultPinTheme: PinTheme(
              width: AppSize.s70,
              height: AppSize.s65,
              textStyle: getSemiBoldStyle(context,
                  font: FontConstants.ojuju, fontSize: FontSize.s20),
              decoration: BoxDecoration(
                color: state.otpComplete == OTPComplete.complete
                    ? colorScheme.tertiary
                    : colorScheme.error,
              ),
            ),
            showCursor: true,
            focusedPinTheme: PinTheme(
              width: AppSize.s70,
              height: AppSize.s65,
              textStyle: getSemiBoldStyle(context,
                  font: FontConstants.ojuju, fontSize: FontSize.s20),
              decoration: BoxDecoration(color: colorScheme.onPrimary),
            ),
          ),
        );
      },
    );
  }
}
