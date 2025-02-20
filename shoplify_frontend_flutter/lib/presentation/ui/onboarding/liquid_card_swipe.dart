import 'package:flutter/material.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';

class LiquidSwipeCard extends StatelessWidget {
  const LiquidSwipeCard({
    super.key,
    required this.gradient,
    required this.buttonColor,
    required this.name,
    required this.action,
    required this.image,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.subtitleColor,
    required this.body,
    required this.bodyColor,
    required this.onTapName,
    required this.onSkip,
    required this.customWidget,
    required this.useCustomWidget,
  });

  final Gradient gradient;
  final Color buttonColor;
  final String name;
  final String action;
  final ImageProvider? image;
  final String title;
  final Color titleColor;
  final String subtitle;
  final Color subtitleColor;
  final String body;
  final Color bodyColor;
  final VoidCallback onTapName;
  final VoidCallback onSkip;
  final Widget customWidget;
  final bool useCustomWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(
              builder: (context) {
                var style = TextStyle(
                    color: buttonColor,
                    fontSize: 15,
                    fontWeight: FontWeightManager.semiBold,
                    fontFamily: FontConstants.poppins);

                return Row(
                  children: [
                    TextButton(
                      onPressed: onTapName,
                      child: Text(
                        name,
                        style: style,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: onSkip,
                      child: Text(
                        action,
                        style: style,
                      ),
                    ),
                    const SizedBox(width: 16.0 * 2),
                  ],
                );
              },
            ),
            const Spacer(),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16),
              child: useCustomWidget == true
                  ? customWidget
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: image!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                  fontSize: FontSize.s50,
                  color: titleColor,
                  fontWeight: FontWeightManager.bold,
                  fontFamily: FontConstants.ojuju),
            ),
            Text(
              subtitle,
              style: TextStyle(
                  fontSize: FontSize.s28,
                  height: 1.0,
                  color: subtitleColor,
                  fontWeight: FontWeightManager.medium,
                  fontFamily: FontConstants.poppins),
            ),
            const SizedBox(height: 16),
            FractionallySizedBox(
              widthFactor: 0.7,
              alignment: Alignment.centerLeft,
              child: Text(
                body,
                style: TextStyle(
                    fontSize: 16,
                    color: bodyColor,
                    fontWeight: FontWeightManager.regular,
                    fontFamily: FontConstants.poppins),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
