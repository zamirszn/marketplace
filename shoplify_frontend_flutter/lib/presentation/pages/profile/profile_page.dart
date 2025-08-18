import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/constants/api_urls.dart';
import 'package:shoplify/presentation/pages/notification/notification_icon.dart';
import 'package:shoplify/presentation/pages/order/bloc/order_bloc.dart';
import 'package:shoplify/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/error_message_widget.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/material_expressive/expressive_shapes.dart';
import 'package:shoplify/presentation/widgets/refresh_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    getProfile();
    super.initState();
  }

  void getProfile() {
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final orderBloc = context.read<OrderBloc>();

    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: false,
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.profile,
          overflow: TextOverflow.ellipsis,
          style: getSemiBoldStyle(
            context,
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
      body: RefreshWidget(
        onRefresh: () {
          getProfile();
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            switch (state.profileStatus) {
              case ProfileStatus.initial || ProfileStatus.loading:
                return const Center(child: LoadingWidget());

              case ProfileStatus.failure:
                return ErrorMessageWidget(
                  retry: () => getProfile(),
                  message: state.errorMessage,
                );

              case ProfileStatus.success:
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p12),
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
                              horizontal: AppPadding.p2,
                              vertical: AppPadding.p5),
                          dense: false,
                          trailing: const EnterArrow(),
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: AnimatedExpressiveShape(
                              morphDuration: const Duration(seconds: 2),
                              shapes: [
                                MaterialShapes.square,
                                MaterialShapes.arch,
                                MaterialShapes.pill,
                                MaterialShapes.cookie4Sided,
                                MaterialShapes.clover4Leaf,
                                MaterialShapes.ghostish,
                                MaterialShapes.bun,
                              ],
                              child: const UserProfilePicture(),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSize.s10)),
                          horizontalTitleGap: AppSize.s14,
                          title: Text(
                            state.profile?.fullName ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: getSemiBoldStyle(
                              context,
                              font: FontConstants.ojuju,
                              fontSize: FontSize.s20,
                            ),
                          ),
                          subtitle: Text(
                            state.profile?.email ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: getRegularStyle(context,
                                font: FontConstants.poppins,
                                color: ColorManager.grey),
                          ),
                        ),
                        space(h: AppSize.s20),
                        RoundCorner(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              AppSize.s10,
                            ),
                            onTap: () {
                              goPush(context, Routes.editProfilePage);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(AppPadding.p20),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.spaceBetween,
                                        runSpacing: AppSize.s20,
                                        children: [
                                          ProfileInfoWidget(
                                            data: state.profile?.phone ?? "-",
                                            iconData: Iconsax.call,
                                            title: AppStrings.phone,
                                          ),
                                          ProfileInfoWidget(
                                            data: state
                                                    .profile?.shippingAddress ??
                                                "-",
                                            iconData: Iconsax.location,
                                            title: AppStrings.shippingAddress,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: AppSize.s1,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: AppSize.s20,
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        space(h: AppSize.s40),
                        Text(AppStrings.myOrders,
                            style: getSemiBoldStyle(context,
                                fontSize: FontSize.s20,
                                font: FontConstants.ojuju)),
                        space(h: AppSize.s10),
                        ListTileWidget(
                          onTap: () {
                            orderBloc.add(SetMyOrderFilter(
                                myOrderFilter:
                                    MyOrderFilter.PAYMENT_STATUS_PENDING));

                            goPush(context, Routes.myOrderPage);
                          },
                          iconData: Iconsax.card,
                          title: AppStrings.pendingPayment,
                        ),
                        ListTileWidget(
                          onTap: () {
                            orderBloc.add(SetMyOrderFilter(
                                myOrderFilter: MyOrderFilter.ORDER_DELIVERED));
                            goPush(context, Routes.myOrderPage);
                          },
                          iconData: Iconsax.truck,
                          title: AppStrings.delivered,
                        ),
                        ListTileWidget(
                          onTap: () {
                            orderBloc.add(SetMyOrderFilter(
                                myOrderFilter:
                                    MyOrderFilter.PAYMENT_STATUS_COMPLETE));
                            goPush(context, Routes.myOrderPage);
                          },
                          iconData: Iconsax.timer_pause,
                          title: AppStrings.processing,
                        ),
                        ListTileWidget(
                          onTap: () {
                            orderBloc.add(SetMyOrderFilter(
                                myOrderFilter: MyOrderFilter.ORDER_CANCELLED));
                            goPush(context, Routes.myOrderPage);
                          },
                          iconData: Iconsax.box_remove,
                          title: AppStrings.cancelled,
                        ),
                        ListTileWidget(
                          onTap: () {
                            orderBloc.add(SetMyOrderFilter(
                                myOrderFilter:
                                    MyOrderFilter.PAYMENT_STATUS_FAILED));
                            goPush(context, Routes.myOrderPage);
                          },
                          iconData: Iconsax.card_remove,
                          title: AppStrings.paymentFailed,
                        ),
                        space(h: AppSize.s20),
                        Text(AppStrings.preferences,
                            style: getSemiBoldStyle(context,
                                fontSize: FontSize.s20,
                                font: FontConstants.ojuju)),
                        space(h: AppSize.s10),
                        ListTileWidget(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              enableDrag: true,
                              builder: (context) =>
                                  const ChangeLanguageBottomsheet(),
                            );
                          },
                          iconData: Iconsax.language_square,
                          title: AppStrings.changeLanguage,
                        ),
                        ListTileWidget(
                          onTap: () {},
                          iconData: Iconsax.notification,
                          title: AppStrings.notifications,
                          trailing: Transform.scale(
                            scale: .8,
                            child: Switch(
                              padding: const EdgeInsets.all(0),
                              value:
                                  state.profile?.notificationsEnabled ?? false,
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        space(h: AppSize.s20),
                        Text(AppStrings.helpAndSupport,
                            style: getSemiBoldStyle(context,
                                fontSize: FontSize.s20,
                                font: FontConstants.ojuju)),
                        space(h: AppSize.s10),
                        ListTileWidget(
                          onTap: () {},
                          iconData: Iconsax.lifebuoy,
                          title: AppStrings.customerService,
                        ),
                        space(h: AppSize.s20),
                        Text(AppStrings.accountAndSecurity,
                            style: getSemiBoldStyle(context,
                                fontSize: FontSize.s20,
                                font: FontConstants.ojuju)),
                        space(h: AppSize.s10),
                        ListTileWidget(
                          onTap: () {},
                          iconData: Iconsax.user_minus,
                          title: AppStrings.deactivateAccount,
                        ),
                        ListTileWidget(
                          onTap: () {},
                          iconData: Iconsax.lock_1,
                          title: AppStrings.changePassword,
                        ),
                        ListTileWidget(
                          onTap: () {},
                          iconData: Iconsax.close_circle,
                          title: AppStrings.logout,
                        ),
                        space(h: AppSize.s100),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return CachedNetworkImage(
          imageUrl: ApiUrls.baseUrl + state.profile?.profilePicture,
          height: 40,
          fit: BoxFit.cover,
          placeholder: (context, url) => Skeletonizer(
              child: Container(
            color: ColorManager.lightGrey,
            height: AppSize.s100,
            width: AppSize.s100,
          )),
          errorWidget: (context, url, error) => Container(
            color: ColorManager.lightGrey,
            height: AppSize.s100,
            width: AppSize.s100,
            child: const Icon(Iconsax.warning_2),
          ),
        );
      },
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
              style: getSemiBoldStyle(context,
                  fontSize: FontSize.s16, font: FontConstants.ojuju),
            ),
          ],
        ),
        space(h: AppSize.s10),
        Text(
          data,
          style: getLightStyle(context,
              fontSize: FontSize.s14, font: FontConstants.poppins),
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

class ListTileWidget extends StatelessWidget {
  const ListTileWidget(
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
        style: getRegularStyle(context, fontSize: FontSize.s14),
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
    final colorScheme = Theme.of(context).colorScheme;

    return RoundCorner(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p7),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: AppSize.s20,
          color: colorScheme.secondary,
        ),
      ),
    );
  }
}
