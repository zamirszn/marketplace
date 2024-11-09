import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/widgets/back_button.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: GoBackButton(),
        ),
        backgroundColor: ColorManager.white,
        forceMaterialTransparency: true,
        title: Text(
          AppStrings.order,
          style: getRegularStyle(
              font: FontConstants.ojuju, fontSize: FontSize.s20),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Badge(
                  label: const Text("2"),
                  backgroundColor: ColorManager.secondary,
                  textColor: ColorManager.white,
                  textStyle: getRegularStyle(font: FontConstants.ojuju),
                  child: Icon(Iconsax.notification)))
        ],
      ),
    );
  }
}
