import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/pages/notification/notification_icon.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          const NotificationIcon(),
          space(
            w: AppSize.s10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  goPush(context, Routes.editProfilePage);
                },
                hoverColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p2, vertical: AppPadding.p5),
                dense: false,
                trailing: const EnterArrow(),
                leading: const CircleAvatar(
                  radius: AppSize.s24,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s10)),
                horizontalTitleGap: AppSize.s14,
                title: Text(
                  "Mubarak Lawal",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getSemiBoldStyle(
                    font: FontConstants.ojuju,
                    fontSize: FontSize.s20,
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
                color: ColorManager.lightGrey,
                child: const Padding(
                  padding: EdgeInsets.all(AppPadding.p20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceBetween,
                        runSpacing: AppSize.s20,
                        children: [
                          ProfileInfoWidget(
                            data: "12/03/1998",
                            iconData: Iconsax.calendar,
                            title: "Joined on",
                          ),
                          ProfileInfoWidget(
                            data: "+23490298903290",
                            iconData: Iconsax.call,
                            title: AppStrings.phone,
                          ),
                          ProfileInfoWidget(
                            data: "No 2b somwhere , Kaduna , New York",
                            iconData: Iconsax.location,
                            title: AppStrings.address,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              space(h: AppSize.s40),
              Text(AppStrings.myOrders,
                  style: getSemiBoldStyle(
                      fontSize: FontSize.s20, font: FontConstants.ojuju)),
              space(h: AppSize.s10),
              ProfileListTileWidget(
                onTap: () {},
                iconData: Iconsax.card,
                title: AppStrings.pendingPayment,
              ),
              ProfileListTileWidget(
                onTap: () {},
                iconData: Iconsax.truck,
                title: AppStrings.delivered,
              ),
              ProfileListTileWidget(
                onTap: () {},
                iconData: Iconsax.timer_pause,
                title: AppStrings.processing,
              ),
              ProfileListTileWidget(
                onTap: () {},
                iconData: Iconsax.box_remove,
                title: AppStrings.cancelled,
              ),
              space(h: AppSize.s20),
              Text(AppStrings.preferences,
                  style: getSemiBoldStyle(
                      fontSize: FontSize.s20, font: FontConstants.ojuju)),
              space(h: AppSize.s10),
              ProfileListTileWidget(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    enableDrag: true,
                    builder: (context) => const ChangeLanguageBottomsheet(),
                  );
                },
                iconData: Iconsax.language_square,
                title: AppStrings.changeLanguage,
              ),
              ProfileListTileWidget(
                onTap: () {},
                iconData: Iconsax.notification,
                title: AppStrings.notifications,
                trailing: Transform.scale(
                  scale: .8,
                  child: Switch(
                    padding: const EdgeInsets.all(0),
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
              ),
              space(h: AppSize.s20),
              Text(AppStrings.helpAndSupport,
                  style: getSemiBoldStyle(
                      fontSize: FontSize.s20, font: FontConstants.ojuju)),
              space(h: AppSize.s10),
              ProfileListTileWidget(
                onTap: () {},
                iconData: Iconsax.lifebuoy,
                title: AppStrings.customerService,
              ),
              space(h: AppSize.s20),
              Text(AppStrings.accountAndSecurity,
                  style: getSemiBoldStyle(
                      fontSize: FontSize.s20, font: FontConstants.ojuju)),
              space(h: AppSize.s10),
              ProfileListTileWidget(
                onTap: () {},
                iconData: Iconsax.user_minus,
                title: AppStrings.deactivateAccount,
              ),
              ProfileListTileWidget(
                onTap: () {},
                iconData: Iconsax.lock_1,
                title: AppStrings.changePassword,
              ),
              ProfileListTileWidget(
                onTap: () {},
                iconData: Iconsax.close_circle,
                title: AppStrings.logout,
              ),
              space(h: AppSize.s100),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInfoWidget extends StatelessWidget {
  const ProfileInfoWidget({
    super.key,
    required this.title,
    required this.data,
    required this.iconData,
  });
  final String title;
  final String data;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              iconData,
              size: AppSize.s20,
            ),
            space(w: AppSize.s6),
            Text(
              title,
              style: getRegularStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                  font: FontConstants.ojuju),
            ),
          ],
        ),
        space(h: AppSize.s10),
        Text(
          data,
          style: getLightStyle(
              fontSize: FontSize.s14,
              color: ColorManager.darkBlue,
              font: FontConstants.poppins),
        ),
      ],
    );
  }
}

class ChangeLanguageBottomsheet extends StatelessWidget {
  const ChangeLanguageBottomsheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ProfileListTileWidget extends StatelessWidget {
  const ProfileListTileWidget(
      {super.key,
      required this.iconData,
      required this.title,
      this.onTap,
      this.trailing});
  final IconData iconData;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: trailing ?? const EnterArrow(),
      hoverColor: ColorManager.grey.withAlpha(100),
      minLeadingWidth: 30,
      contentPadding: const EdgeInsets.symmetric(
          vertical: AppPadding.p5, horizontal: AppPadding.p10),
      onTap: onTap,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s10)),
      leading: Icon(iconData),
      title: Text(
        title,
        style: getRegularStyle(fontSize: FontSize.s14),
      ),
    );
  }
}

class EnterArrow extends StatelessWidget {
  const EnterArrow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RoundCorner(
      color: ColorManager.lightGrey,
      child: const Padding(
        padding: EdgeInsets.all(AppPadding.p7),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: AppSize.s20,
        ),
      ),
    );
  }
}
