import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/presentation/resources/color_manager.dart';
import 'package:marketplace/presentation/shared/back_button.dart';

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
