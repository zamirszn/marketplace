import 'package:flutter/material.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

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
  const RoundCorner(
      {super.key, required this.child, this.borderRadius, this.color});
  final Widget child;
  final double? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      child: ColoredBox(color: color ?? colorScheme.onPrimary, child: child),
    );
  }
}

class Required extends StatelessWidget {
  const Required({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        child,
        space(w: AppSize.s2),
        Text(
          "*",
          style: TextStyle(color: ColorManager.red, fontSize: FontSize.s20),
        )
      ],
    );
  }
}

class ReadMoreText extends StatefulWidget {
  final String text;
  final int trimLines;

  const ReadMoreText({
    super.key,
    required this.text,
    this.trimLines = 3,
  });

  @override
  ReadMoreTextState createState() => ReadMoreTextState();
}

class ReadMoreTextState extends State<ReadMoreText> {
  bool _readMore = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Text(
            widget.text,
            overflow: TextOverflow.fade,
            maxLines: _readMore ? null : widget.trimLines,
            style: getLightStyle(context, fontSize: FontSize.s14),
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () {
            setState(() {
              _readMore = !_readMore;
            });
          },
          child: Text(
            _readMore ? 'Read less' : 'Read more',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
