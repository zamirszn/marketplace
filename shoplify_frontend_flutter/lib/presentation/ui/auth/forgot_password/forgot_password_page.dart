import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/auth/account_verification/bloc/account_verification_bloc.dart';
import 'package:shoplify/presentation/ui/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:shoplify/presentation/ui/auth/sign_up/sign_up_page.dart';
import 'package:shoplify/presentation/widgets/back_button.dart';
import 'package:shoplify/presentation/widgets/count_down_widget/bloc/countdown_bloc.dart';
import 'package:shoplify/presentation/widgets/count_down_widget/countdown_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  // TODO: remove
  final emailController = TextEditingController(
      text: kDebugMode ? "testmail1740387123456053@gmail.com" : null);
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
    return Scaffold(
        backgroundColor: ColorManager.yellow,
        extendBodyBehindAppBar: true,
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
              return SizedBox(
                height: deviceHeight(context),
                width: deviceWidth(context),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.s20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          space(h: AppSize.s40),

                          GoBackButton(
                            color: ColorManager.white,
                            backgroundColor: ColorManager.black,
                            padding: const EdgeInsets.all(AppPadding.p8),
                          ),

                          space(h: AppSize.s20),
                          Text(
                            AppStrings.lostYourPassword,
                            textAlign: TextAlign.start,
                            style: getBoldStyle(
                                color: ColorManager.black,
                                font: FontConstants.poppins,
                                fontSize: AppSize.s50),
                          ),
                          space(h: deviceHeight(context) * .16),
                          Text(
                            AppStrings.emailAddress,
                            style: getSemiBoldStyle(
                                color: ColorManager.black,
                                font: FontConstants.poppins,
                                fontSize: FontSize.s16),
                          ),
                          space(h: AppSize.s10),
                          Animate(
                            controller: _animationController,
                            autoPlay: false,
                            effects: [Constant.shakeEffect],
                            child: TextFormField(
                                cursorColor: cursorColor,
                                style: getRegularStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s20),
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
                                  prefixIcon: Icon(
                                    Iconsax.sms,
                                    color: ColorManager.black,
                                  ),
                                  errorStyle: errorStyle,
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
                          ),

                          // use animated switcher to show
                          // otp field
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
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:
                                                  ColorManager.white),
                                          onPressed: () {
                                            if (formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              context
                                                  .read<ForgotPasswordBloc>()
                                                  .add(RequestForgotEvent(
                                                      shouldRedirect: true,
                                                      email: emailController
                                                          .text));
                                            } else {
                                              triggerShake();
                                            }
                                          },
                                          child: Text(
                                            AppStrings.continue_,
                                            style: getSemiBoldStyle(
                                                font: FontConstants.ojuju,
                                                fontSize: FontSize.s20,
                                                color: ColorManager.black),
                                          )))),

                          space(h: AppSize.s36),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
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
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Pinput(
              scrollPadding: const EdgeInsets.only(bottom: AppSize.s470),
              onChanged: (value) {
                // context.read<ForgotPasswordBloc>().add(OTPCompleteEvent(
                //     otpComplete: OTPComplete.incomplete,
                //     otp: int.parse(controller.text)));
              },
              onCompleted: (value) {
                // context.read<ForgotPasswordBloc>().add(OTPCompleteEvent(
                //     otpComplete: OTPComplete.complete,
                //     otp: int.parse(controller.text)));
              },
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
                color: ColorManager.lightBlue,
              ),
              defaultPinTheme: PinTheme(
                width: AppSize.s70,
                height: AppSize.s65,
                textStyle: getSemiBoldStyle(
                    color: ColorManager.black,
                    font: FontConstants.ojuju,
                    fontSize: FontSize.s20),
                decoration: BoxDecoration(
                    color: state.otpComplete == OTPComplete.complete
                        ? ColorManager.green
                        : ColorManager.red),
              ),
              showCursor: true,
              focusedPinTheme: PinTheme(
                width: AppSize.s70,
                height: AppSize.s65,
                textStyle: getSemiBoldStyle(
                    color: ColorManager.black,
                    font: FontConstants.ojuju,
                    fontSize: FontSize.s20),
                decoration: BoxDecoration(color: ColorManager.black),
              ),
            ));
      },
    );
  }
}
