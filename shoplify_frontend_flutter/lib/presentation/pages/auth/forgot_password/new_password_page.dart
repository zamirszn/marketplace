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
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/count_down_widget/bloc/countdown_bloc.dart';
import 'package:shoplify/presentation/widgets/count_down_widget/countdown_widget.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key, required this.emailToSendOTP});
  final String emailToSendOTP;

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final newPasswordController =
      TextEditingController(text: kDebugMode ? "Zamirszn52#" : null);
  final confirmPasswordController =
      TextEditingController(text: kDebugMode ? "Zamirszn52#" : null);

  @override
  void dispose() {
    confirmPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BlocProvider.of<CountdownBloc>(context).add(CountdownStartEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBlue,
      extendBodyBehindAppBar: true,
      body: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
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
                      space(h: AppSize.s20),
                      GoBackButton(
                        color: ColorManager.white,
                        backgroundColor: ColorManager.black,
                        padding: const EdgeInsets.all(AppPadding.p8),
                      ),
                      space(h: AppSize.s20),
                      Text(
                        AppStrings.enterYourNewPassword,
                        textAlign: TextAlign.start,
                        style: getBoldStyle(context,
                            font: FontConstants.poppins, fontSize: AppSize.s50),
                      ),
                      space(h: AppSize.s60),
                      Text(
                        AppStrings.newPassword,
                        style: getSemiBoldStyle(context,
                            font: FontConstants.poppins,
                            fontSize: FontSize.s16),
                      ),
                      space(h: AppSize.s10),
                      TextFormField(
                          cursorColor: cursorColor,
                          style: getRegularStyle(context,
                              fontSize: FontSize.s20),
                          obscureText:
                              state.passwordVisibility == PasswordVisibility.on
                                  ? false
                                  : true,
                          validator: (value) {
                            return passwordValidator(value);
                          },
                          controller: newPasswordController,
                          autofillHints: const [AutofillHints.newPassword],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                Constant.passwordLength),
                          ],
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Iconsax.lock,
                              color: ColorManager.black,
                            ),
                            suffix: GestureDetector(
                              onTap: () {
                                context.read<ForgotPasswordBloc>().add(
                                    ForgotPasswordVisibileEvent(
                                        isPasswordVisible:
                                            state.passwordVisibility));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
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
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: AppPadding.p14,
                                horizontal: AppPadding.p5),
                            border:
                                outlineInputBorder(color: ColorManager.black),
                            focusedBorder:
                                outlineInputBorder(color: ColorManager.black),
                            enabledBorder:
                                outlineInputBorder(color: ColorManager.black),
                            errorBorder:
                                outlineInputBorder(color: ColorManager.white),
                            disabledBorder:
                                outlineInputBorder(color: ColorManager.black),
                            focusedErrorBorder:
                                outlineInputBorder(color: ColorManager.white),
                          )),
                      space(h: AppSize.s20),
                      Text(
                        AppStrings.confirmPassword,
                        style: getSemiBoldStyle(context,
                            font: FontConstants.poppins,
                            fontSize: FontSize.s16),
                      ),
                      space(h: AppSize.s10),
                      TextFormField(
                        cursorColor: cursorColor,
                        style: getRegularStyle(context,
                            fontSize: FontSize.s20),
                        obscureText:
                            state.passwordVisibility == PasswordVisibility.on
                                ? false
                                : true,
                        validator: (value) {
                          if (newPasswordController.text !=
                              confirmPasswordController.text) {
                            return AppStrings.passwordsDoesntMatch;
                          }
                          return passwordValidator(value);
                        },
                        controller: confirmPasswordController,
                        autofillHints: const [AutofillHints.newPassword],
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              Constant.passwordLength),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Iconsax.password_check,
                            color: ColorManager.black,
                          ),
                          suffix: GestureDetector(
                            onTap: () {
                              context.read<ForgotPasswordBloc>().add(
                                  ForgotPasswordVisibileEvent(
                                      isPasswordVisible:
                                          state.passwordVisibility));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: AppPadding.p14,
                              horizontal: AppPadding.p5),
                          border: outlineInputBorder(color: ColorManager.black),
                          focusedBorder:
                              outlineInputBorder(color: ColorManager.black),
                          enabledBorder:
                              outlineInputBorder(color: ColorManager.black),
                          errorBorder:
                              outlineInputBorder(color: ColorManager.white),
                          disabledBorder:
                              outlineInputBorder(color: ColorManager.black),
                          focusedErrorBorder:
                              outlineInputBorder(color: ColorManager.white),
                        ),
                      ),
                      space(h: AppSize.s36),
                      Center(
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: AppSize.s400,
                                  minHeight: AppSize.s50,
                                  maxHeight: AppSize.s50,
                                  maxWidth: AppSize.s400),
                              child: ElevatedButton(
                                  
                                  onPressed: () {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      showModalBottomSheet(
                                        context: context,
                                        isDismissible: true,
                                        showDragHandle: true,
                                        isScrollControlled: true,
                                        enableDrag: true,
                                        builder: (context) => SizedBox(
                                            height: deviceHeight(context) * .7,
                                            child: ResetPasswordOTPBottomSheet(
                                              email: widget.emailToSendOTP,
                                              newPassword:
                                                  confirmPasswordController
                                                      .text,
                                            )),
                                      );
                                    }
                                  },
                                  child: Text(
                                    AppStrings.continue_,
                                    style: getSemiBoldStyle(
                                      context,
                                      font: FontConstants.ojuju,
                                      fontSize: FontSize.s20,
                                    ),
                                  )))),
                      space(h: AppSize.s40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ResetPasswordOTPBottomSheet extends StatefulWidget {
  const ResetPasswordOTPBottomSheet(
      {super.key, required this.email, required this.newPassword});
  final String email;
  final String newPassword;

  @override
  State<ResetPasswordOTPBottomSheet> createState() =>
      _ResetPasswordOTPBottomSheetState();
}

class _ResetPasswordOTPBottomSheetState
    extends State<ResetPasswordOTPBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    context.read<ForgotPasswordBloc>().add(ResetPasswordOTPCompleteEvent(
        otpComplete: OTPComplete.incomplete, otp: null));
    super.initState();
  }

  void triggerShake() {
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  space(h: AppSize.s20),
                  SizedBox(
                    height: AppSize.s40,
                    width: AppSize.s40,
                    child: GoBackButton(
                      color: ColorManager.white,
                      backgroundColor: ColorManager.black,
                      padding: const EdgeInsets.all(AppPadding.p8),
                    ),
                  ),
                  space(h: AppSize.s20),
                  space(h: AppSize.s36),
                  Center(
                    child: Text(
                      AppStrings.enterCodeSent,
                      textAlign: TextAlign.center,
                      style: getLightStyle(
                        context,
                        font: FontConstants.poppins,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                  space(h: AppSize.s20),
                  Center(
                      child: Animate(
                          controller: _animationController,
                          autoPlay: false,
                          effects: [Constant.shakeEffect],
                          child: const ResetPasswordFilledInput())),
                  space(h: AppSize.s60),
                  Center(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              minWidth: AppSize.s290,
                              minHeight: AppSize.s50,
                              maxHeight: AppSize.s50,
                              maxWidth: AppSize.s400),
                          child: state.forgotPasswordStatus ==
                                  ForgotPasswordStatus.submittingNewPassword
                              ? Center(
                                  child: Transform.scale(
                                      scale: .8, child: const LoadingWidget()))
                              : ElevatedButton(
                                  
                                  onPressed: () {
                                    if (state.otpCode != null) {
                                      context.read<ForgotPasswordBloc>().add(
                                          SubmitNewPasswordOTPEvent(
                                              resetPasswordParams:
                                                  ResetPasswordParams(
                                                      email: widget.email,
                                                      otp: state.otpCode!,
                                                      password:
                                                          widget.newPassword)));
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
                                  )))),
                  space(h: AppSize.s20),
                  if (state.isRequestingOTP)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.requestAgainIn,
                          style: getRegularStyle(context,
                              fontSize: FontSize.s14),
                        ),
                        space(w: AppSize.s4),
                        CountdownWidget(
                          callback: () {
                            context
                                .read<ForgotPasswordBloc>()
                                .add(CanRequestPasswordOTPEvent());
                          },
                        )
                      ],
                    ),
                  if (!state.isRequestingOTP)
                    GestureDetector(
                      onTap: () {
                        context.read<ForgotPasswordBloc>().add(
                            RequestForgotEvent(
                                email: widget.email, shouldRedirect: false));
                        context
                            .read<CountdownBloc>()
                            .add(CountdownStartEvent());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.didntRecieveOTP,
                            style: getRegularStyle(context,
                                fontSize: FontSize.s14),
                          ),
                          space(w: AppSize.s4),
                          Text(
                            AppStrings.resendCode,
                            style: getSemiBoldStyle(
                              context,
                              fontSize: FontSize.s14,
                            ),
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
    );
  }
}

class ResetPasswordFilledInput extends StatefulWidget {
  const ResetPasswordFilledInput({super.key});

  @override
  ResetPasswordFilledInputState createState() =>
      ResetPasswordFilledInputState();
}

class ResetPasswordFilledInputState extends State<ResetPasswordFilledInput> {
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
                context.read<ForgotPasswordBloc>().add(
                    ResetPasswordOTPCompleteEvent(
                        otpComplete: OTPComplete.incomplete,
                        otp: controller.text.isEmpty
                            ? null
                            : int.tryParse(controller.text)));
              },
              onCompleted: (value) {
                context.read<ForgotPasswordBloc>().add(
                    ResetPasswordOTPCompleteEvent(
                        otpComplete: OTPComplete.complete,
                        otp: controller.text.isEmpty
                            ? null
                            : int.tryParse(controller.text)));
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
                textStyle: getSemiBoldStyle(context,
                    font: FontConstants.ojuju, fontSize: FontSize.s20),
                decoration: BoxDecoration(
                    color: state.otpComplete == OTPComplete.complete
                        ? ColorManager.green
                        : ColorManager.red),
              ),
              showCursor: true,
              focusedPinTheme: PinTheme(
                width: AppSize.s70,
                height: AppSize.s65,
                textStyle: getSemiBoldStyle(context,
                    font: FontConstants.ojuju, fontSize: FontSize.s20),
                decoration: BoxDecoration(color: ColorManager.black),
              ),
            ));
      },
    );
  }
}
