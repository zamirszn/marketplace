import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/constants/api_urls.dart';
import 'package:shoplify/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/loading/loading_indicator.dart';
import 'package:shoplify/presentation/widgets/material_expressive/nine_sided_cookie.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        leading: Padding(
          padding: const EdgeInsets.all(AppPadding.p10),
          child: GoBackButton(
            backgroundColor: ColorManager.lightGrey,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Transform.scale(
              scale: 3,
              child: LoadingIndicator.contained(),
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Transform.scale(
                scale: 2,
                child: CookieImage(
                  imageUrl: ApiUrls.baseUrl + state.profile?.profilePicture,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
