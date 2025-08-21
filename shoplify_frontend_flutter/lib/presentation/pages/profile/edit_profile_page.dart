import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/data/models/response_models.dart';
import 'package:shoplify/presentation/pages/auth/sign_up/sign_up_page.dart';
import 'package:shoplify/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:shoplify/presentation/pages/profile/profile_page.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/material_expressive/expressive_shapes.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final emailController = TextEditingController();
  final shippingAddressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final ProfileModel? userProfile = context.read<ProfileBloc>().state.profile;
    emailController.text = userProfile?.email ?? "";
    phoneNumberController.text = userProfile?.phone ?? "";
    shippingAddressController.text = userProfile?.shippingAddress ?? "";
    fullNameController.text = userProfile?.fullName ?? "";
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    shippingAddressController.dispose();
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
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.updateProfileStatus == UpdateProfileStatus.failure) {
              if (state.errorMessage != null) {
                showErrorMessage(context, state.errorMessage!);
              }
            }
            else if (state.updateProfileStatus == UpdateProfileStatus.success){
                showMessage(context, AppStrings.profileUpdateSuccess);
            }
          },
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            space(h: AppSize.s40),
                            Center(
                              child: RotatingMaterialShape(
                                shape: MaterialShapes.cookie9Sided,
                                child: const UserProfilePicture(),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: AppSize.s20,
                          right: AppSize.s40,
                          child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: colorScheme.onPrimary,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  showDragHandle: true,
                                  context: context,
                                  builder: (context) =>
                                      const EditProfilePictureBottomSheet(),
                                );
                              },
                              icon: const Icon(Iconsax.gallery_edit)),
                        )
                      ],
                    ),
                    space(h: AppSize.s40),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s24)),
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppPadding.p2),
                      margin: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p20),
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
                              keyboardType: TextInputType.name,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: getRegularStyle(context,
                                  fontSize: FontSize.s18),
                              validator: nameValidator,
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
                            // email
                            TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: getRegularStyle(context,
                                    fontSize: FontSize.s18),
                                validator: emailValidator,
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
                            // phone

                            space(h: AppSize.s20),

                            Text(
                              AppStrings.phoneNumber,
                              style: getSemiBoldStyle(context,
                                  font: FontConstants.poppins,
                                  fontSize: FontSize.s16),
                            ),
                            space(h: AppSize.s10),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,

                              style: getRegularStyle(context,
                                  fontSize: FontSize.s18),
                              validator: phoneNumValidator,
                              // onChanged: (value) => context
                              //     .read<SignUpBloc>()
                              //     .add(SignUpFullNameChangedEvent(value)),
                              controller: phoneNumberController,
                              autofillHints: const [
                                AutofillHints.telephoneNumber
                              ],
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                    Constant.phoneLength),
                              ],
                              decoration: const InputDecoration(
                                hintText: AppStrings.phoneNumber,
                                prefixIcon: Icon(
                                  Iconsax.call,
                                ),
                              ),
                            ),
                            // shipping addr

                            space(h: AppSize.s20),

                            Text(
                              AppStrings.shippingAddress,
                              style: getSemiBoldStyle(context,
                                  font: FontConstants.poppins,
                                  fontSize: FontSize.s16),
                            ),
                            space(h: AppSize.s10),
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLength: 300,
                              maxLines: 2,
                              minLines: 2,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: getRegularStyle(context,
                                  fontSize: FontSize.s18),
                              validator: addressValidator,
                              controller: shippingAddressController,
                              autofillHints: const [
                                AutofillHints.fullStreetAddress
                              ],
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                    Constant.addressLength),
                              ],
                              decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                hintText: AppStrings.shippingAddress,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(bottom: 22),
                                  child: Icon(
                                    Iconsax.location,
                                  ),
                                ),
                              ),
                            ),
                            space(h: AppSize.s40),
                            // save button
                            SizedBox(
                              height: AppSize.s50,
                              width: double.infinity,
                              child: BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, state) {
                                  if (state.updateProfileStatus ==
                                      UpdateProfileStatus.loading) {
                                    return const ButtonLoadingWidget();
                                  } else {
                                    return ElevatedButton(
                                      onPressed: () {
                                        TextInput.finishAutofillContext(
                                            shouldSave: true);

                                        if (formKey.currentState?.validate() ??
                                            false) {
                                          context.read<ProfileBloc>().add(
                                              UpdateProfileEvent(
                                                  params: ProfileModel(
                                                      email:
                                                          emailController.text,
                                                      fullName:
                                                          fullNameController
                                                              .text,
                                                      phone:
                                                          phoneNumberController
                                                              .text,
                                                      shippingAddress:
                                                          shippingAddressController
                                                              .text)));
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
                                    );
                                  }
                                },
                              ),
                            ),
                            space(h: AppSize.s40),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }
}

class EditProfilePictureBottomSheet extends StatelessWidget {
  const EditProfilePictureBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Upload photo",
          style: getMediumStyle(context,
              font: FontConstants.ojuju, fontSize: FontSize.s23),
        ),
        space(h: AppSize.s20),
        ListTileWidget(
          onTap: () {
            pickImage(context, ImageSource.camera);
          },
          iconData: Iconsax.camera,
          title: AppStrings.camera,
        ),
        ListTileWidget(
          onTap: () {
            pickImage(context, ImageSource.gallery);
          },
          iconData: Iconsax.gallery,
          title: AppStrings.gallery,
        ),
        space(h: AppSize.s20)
      ],
    );
  }
}
