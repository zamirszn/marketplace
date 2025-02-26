import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  // TODO: remove
  final emailController = TextEditingController(
      text: kDebugMode ? "mubaraklawal52@gmail.com" : null);
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
    final errorStyle =
        getRegularStyle(color: ColorManager.white, fontSize: FontSize.s10);
    final cursorColor = ColorManager.white;
    return Scaffold(
        backgroundColor: ColorManager.yellow,
        extendBodyBehindAppBar: true,
        body: SizedBox(
          height: deviceHeight(context),
          width: deviceWidth(context),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    space(h: AppSize.s40),
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
                          onChanged: (value) {
                            // context.read<LoginBloc>().add(
                            //     LoginEmailChangedEvent(value));
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
                            border:
                                outlineInputBorder(color: ColorManager.black),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: AppPadding.p14,
                                horizontal: AppPadding.p10),
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
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: ColorManager.white),
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                // context.read<LoginBloc>().add(
                                //     LoginSubmittedEvent(
                                //         params: LoginParamsModel(
                                //             email: emailController.text
                                //                 .toLowerCase(),
                                //             // emails are case sensitive
                                //             password:
                                //                 passwordController.text)));
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
                            )),
                      ),
                    ),
                    space(h: AppSize.s36),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
