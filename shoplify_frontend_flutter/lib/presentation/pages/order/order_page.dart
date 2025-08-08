import 'package:flutter/material.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/pages/notification/notification_icon.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: GoBackButton(),
        ),
        backgroundColor: ColorManager.white,
        forceMaterialTransparency: true,
        title: Text(
          AppStrings.order,
          style: getRegularStyle(context,
              font: FontConstants.ojuju, fontSize: FontSize.s20),
        ),
        actions: [
          const NotificationIcon(),
          space(
            w: AppSize.s10,
          )
        ],
      ),
    );
  }
}
