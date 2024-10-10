import 'package:flutter/material.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/widgets/back_button.dart';

class ItemDetailsPage extends StatelessWidget {
  const ItemDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: false,
          leading: const GoBackButton(),
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          height: deviceHeight(context),
          width: deviceWidth(context),
          color: ColorManager.color3,
        ));
  }
}
