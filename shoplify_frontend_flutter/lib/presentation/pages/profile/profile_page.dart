import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
          AppStrings.profile,
          overflow: TextOverflow.ellipsis,
          style: getSemiBoldStyle(
            font: FontConstants.ojuju,
            fontSize: AppSize.s24,
          ),
        ),
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        actions: [
          Badge(
            label: const Text("3"),
            alignment: const AlignmentDirectional(.7, -.8),
            backgroundColor: ColorManager.darkBlue,
            textColor: ColorManager.white,
            textStyle: getRegularStyle(font: FontConstants.ojuju),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Iconsax.notification),
            ),
          ),
          space(
            w: AppSize.s10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p2, vertical: AppPadding.p5),
                dense: false,
                trailing: RoundCorner(
                  color: ColorManager.lightGrey,
                  child: IconButton(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: AppSize.s20,
                      )),
                ),
                leading: const CircleAvatar(
                  radius: AppSize.s28,
                ),
                horizontalTitleGap: AppSize.s14,
                title: Text(
                  "Mubarak Lawal",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getSemiBoldStyle(
                    font: FontConstants.ojuju,
                    fontSize: FontSize.s18,
                  ),
                ),
                subtitle: Text(
                  "Mubaraklawal52@gmail.com",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getRegularStyle(
                      font: FontConstants.poppins, color: ColorManager.grey),
                ),
              ),
              space(h: AppSize.s20),
              RoundCorner(
                child: Container(
                  height: AppSize.s200,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
