import 'package:flutter/material.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';

class Error404Page extends StatelessWidget {
  const Error404Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(AppPadding.p10),
          child: GoBackButton(
            backgroundColor: ColorManager.black,
            color: ColorManager.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "404",
            textAlign: TextAlign.center,
            style: getBoldStyle(context,
                font: FontConstants.ojuju, fontSize: FontSize.s35),
          ),
          space(h: AppSize.s20),
          Text(
            AppStrings.pageNotFound,
            textAlign: TextAlign.center,
            style: getLightStyle(context,
                color: ColorManager.black,
                font: FontConstants.poppins,
                fontSize: FontSize.s23),
          ),
        ],
      ),
    );
  }
}
