import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

class BlurBackgroundWidget extends StatelessWidget {
  const BlurBackgroundWidget({super.key, required this.child, this.width});
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(
          AppSize.s10,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 6,
            sigmaY: 6,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withAlpha(40),
                borderRadius: BorderRadius.circular(
                  AppSize.s10,
                )),
            padding: const EdgeInsets.symmetric(
                vertical: AppPadding.p5, horizontal: AppPadding.p10),
            child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: width ?? 90),
                child: child),
          ),
        ));
  }
}
