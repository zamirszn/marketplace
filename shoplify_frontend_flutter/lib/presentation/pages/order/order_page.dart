import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/widgets/back_button.dart';

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
          style: getRegularStyle(
              font: FontConstants.ojuju, fontSize: FontSize.s20),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Badge(
                  label: const Text("2"),
                  backgroundColor: ColorManager.darkBlue,
                  textColor: ColorManager.white,
                  textStyle: getRegularStyle(font: FontConstants.ojuju),
                  child: const Icon(Iconsax.notification)))
        ],
      ),
    );
  }
}
