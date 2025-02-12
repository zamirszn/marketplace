import 'package:flutter/material.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color ?? ColorManager.primary,
    );
  }
}
