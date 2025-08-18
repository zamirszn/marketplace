import 'package:flutter/material.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton(
      {super.key, this.color, this.padding, this.backgroundColor});
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: AppStrings.back,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.s10),
        child: Material(
          color: Colors.transparent,
          child: ColoredBox(
            color: backgroundColor ?? colorScheme.onPrimary,
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              onTap: () => goPopRoute(context),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: color ?? colorScheme.secondary,
                  size: AppSize.s20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
