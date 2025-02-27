import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/data/models/verify_otp_params.dart';
import 'package:shoplify/presentation/resources/asset_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/auth/account_verification/bloc/account_verification_bloc.dart';
import 'package:shoplify/presentation/ui/auth/login/bloc/login_bloc.dart';
import 'package:shoplify/presentation/ui/auth/sign_up/sign_up_page.dart';
import 'package:shoplify/presentation/widgets/count_down_widget/bloc/countdown_bloc.dart';
import 'package:shoplify/presentation/widgets/count_down_widget/countdown_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class AccountVerificationPage extends StatefulWidget {
  const AccountVerificationPage({super.key});

  @override
  State<AccountVerificationPage> createState() =>
      _AccountVerificationPageState();
}

class _AccountVerificationPageState extends State<AccountVerificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    final emailToVerify = context.read<LoginBloc>().state.email;
    BlocProvider.of<AccountVerificationBloc>(context)
        .add(ResendOTPEvent(email: emailToVerify));
    BlocProvider.of<CountdownBloc>(context).add(CountdownStartEvent());
    super.initState();
  }

  void triggerShake() {
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final emailToVerify = context.read<LoginBloc>().state.email;
    return BlocBuilder<AccountVerificationBloc, AccountVerificationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: state.otpComplete == OTPComplete.complete
              ? ColorManager.green
              : ColorManager.red,
          extendBodyBehindAppBar: true,
          body: BlocListener<AccountVerificationBloc, AccountVerificationState>(
            listener: (context, state) {
              if (state.verificationStatus == VerificationStatus.failure) {
                if (state.errorMessage != null) {
                  showMessage(context, state.errorMessage!);
                }
              } else if (state.verificationStatus ==
                  VerificationStatus.success) {
                goto(context, Routes.bottomNav);
              }
            },
            child: SizedBox(
              height: deviceHeight(context),
              width: deviceWidth(context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      space(h: AppSize.s40),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppSize.s10,
                        ),
                        child: Text(
                          AppStrings.greatNowLets,
                          textAlign: TextAlign.start,
                          style: getBoldStyle(
                              color: ColorManager.black,
                              font: FontConstants.poppins,
                              fontSize: AppSize.s50),
                        ),
                      ),
                      space(h: deviceHeight(context) * .16),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p10),
                          decoration: BoxDecoration(
                              color: ColorManager.white,
                              borderRadius: BorderRadius.circular(AppSize.s14)),
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 330,
                                  minHeight: AppSize.s314,
                                  maxWidth: 400),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  space(h: AppSize.s36),
                                  Text(
                                    AppStrings.enterCodeSent,
                                    textAlign: TextAlign.center,
                                    style: getLightStyle(
                                        font: FontConstants.poppins,
                                        fontSize: FontSize.s12,
                                        color: ColorManager.lightGrey),
                                  ),
                                  space(h: AppSize.s20),
                                  Center(
                                      child: Animate(
                                          controller: _animationController,
                                          autoPlay: false,
                                          effects: [Constant.shakeEffect],
                                          child:
                                              const VerifyAccountFilledInput())),
                                  space(h: AppSize.s36),
                                  Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: 280,
                                          minHeight: AppSize.s50,
                                          maxHeight: AppSize.s50,
                                          maxWidth: AppSize.s400),
                                      child: state.verificationStatus ==
                                              VerificationStatus.loading
                                          ? Center(
                                              child: Transform.scale(
                                                  scale: .7,
                                                  child: const LoadingWidget()))
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      ColorManager.black),
                                              onPressed: () {
                                                if (state.otpCode != null) {
                                                  context
                                                      .read<
                                                          AccountVerificationBloc>()
                                                      .add(SubmitEmailVerificationOTPEvent(
                                                          params: VerifyOtpParams(
                                                              email:
                                                                  emailToVerify!,
                                                              otp: state
                                                                  .otpCode!)));
                                                } else {
                                                  triggerShake();
                                                }
                                              },
                                              child: Text(
                                                AppStrings.verify,
                                                style: getSemiBoldStyle(
                                                    font: FontConstants.ojuju,
                                                    fontSize: FontSize.s20,
                                                    color: ColorManager.white),
                                              )),
                                    ),
                                  ),
                                  if (state.isRequestingOTP)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppStrings.requestAgainIn,
                                          style: getRegularStyle(
                                              color: ColorManager.black,
                                              fontSize: FontSize.s14),
                                        ),
                                        space(w: AppSize.s4),
                                        CountdownWidget(
                                          callback: () {
                                            context
                                                .read<AccountVerificationBloc>()
                                                .add(CanRequestEmailOTPEvent());
                                          },
                                        )
                                      ],
                                    ),
                                  if (!state.isRequestingOTP)
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<AccountVerificationBloc>()
                                            .add(ResendOTPEvent(
                                                email: emailToVerify));
                                        context
                                            .read<CountdownBloc>()
                                            .add(CountdownStartEvent());
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppStrings.didntRecieveOTP,
                                            style: getRegularStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s14),
                                          ),
                                          space(w: AppSize.s4),
                                          Text(
                                            AppStrings.resendCode,
                                            style: getSemiBoldStyle(
                                                fontSize: FontSize.s14,
                                                color: ColorManager.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  space(h: AppSize.s20),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
    return BlocBuilder<AccountVerificationBloc, AccountVerificationState>(
      builder: (context, state) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Pinput(
              scrollPadding: const EdgeInsets.only(bottom: AppSize.s470),
              onChanged: (value) {
                context.read<AccountVerificationBloc>().add(
                    EmailVerificationOTPCompleteEvent(
                        otpComplete: OTPComplete.incomplete,
                        otp: controller.text.isEmpty
                            ? null
                            : int.tryParse(controller.text)));
              },
              onCompleted: (value) {
                context.read<AccountVerificationBloc>().add(
                    EmailVerificationOTPCompleteEvent(
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
