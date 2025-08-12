import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/presentation/pages/profile/profile_page.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/material_expressive/expressive_shapes.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        extendBodyBehindAppBar: false,
        extendBody: false,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppStrings.editprofile,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              context,
              font: FontConstants.ojuju,
              fontSize: AppSize.s24,
            ),
          ),
          forceMaterialTransparency: true,
          actions: const [],
          leading: const Padding(
            padding: EdgeInsets.all(AppPadding.p10),
            child: GoBackButton(),
          ),
        ),
        body: Form(
          key: formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                space(h: AppSize.s40),
                Center(
                  child: RotatingMaterialShape(
                    shape: MaterialShapes.cookie9Sided,
                    child: const UserProfilePicture(),
                  ),
                ),
                space(h: AppSize.s40),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s24)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p2),
                  margin:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        space(h: AppSize.s20),
                        Text(
                          AppStrings.fullName,
                          style: getSemiBoldStyle(context,
                              font: FontConstants.poppins,
                              fontSize: FontSize.s16),
                        ),
                        space(h: AppSize.s10),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,

                          style:
                              getRegularStyle(context, fontSize: FontSize.s20),
                          validator: nameValidator,
                          // onChanged: (value) => context
                          //     .read<SignUpBloc>()
                          //     .add(SignUpFullNameChangedEvent(value)),
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
                        Text(
                          AppStrings.emailAddress,
                          style: getSemiBoldStyle(context,
                              font: FontConstants.poppins,
                              fontSize: FontSize.s16),
                        ),
                        space(h: AppSize.s10),
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: getRegularStyle(context,
                                fontSize: FontSize.s20),
                            validator: emailValidator,
                            // onChanged: (value) => context
                            //     .read<SignUpBloc>()
                            //     .add(SignUpEmailChangedEvent(value)),
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
                        space(h: AppSize.s40),
                        SizedBox(
                          height: AppSize.s50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              TextInput.finishAutofillContext(shouldSave: true);

                              if (formKey.currentState?.validate() ?? false) {
                                // context
                                //     .read<SignUpBloc>()
                                //     .add(SignUpSubmittedEvent(
                                //         params: SignupParamsModel(
                                //       fullName:
                                //           fullNameController.text,
                                //       email: emailController.text,
                                //       password:
                                //           passwordController.text,
                                //     )));
                              }
                            },
                            child: Text(
                              AppStrings.save,
                              style: getSemiBoldStyle(
                                context,
                                font: FontConstants.ojuju,
                                fontSize: FontSize.s20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }
}
