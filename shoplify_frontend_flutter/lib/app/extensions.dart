import 'package:flutter/material.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';

extension PascalCase on String {
  String toPascalCase() {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}

class FadeInPageTransition extends PageTransitionsBuilder {
  const FadeInPageTransition();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class SlidePageTransition extends PageTransitionsBuilder {
  const SlidePageTransition();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class RedBox extends StatelessWidget {
  const RedBox({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.red,
      child: child,
    );
  }
}

class RoundCorner extends StatelessWidget {
  const RoundCorner({super.key, required this.child, this.borderRadius});
  final Widget child;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      child: ColoredBox(color: ColorManager.grey.withAlpha(200), child: child),
    );
  }
}
