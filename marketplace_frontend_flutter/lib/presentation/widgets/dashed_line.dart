import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    this.strokeWidth,
    this.spacing,
    this.color,
    this.strokeThickness,
  });
  final double? strokeWidth;
  final double? spacing;
  final Color? color;
  final double? strokeThickness;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomPaint(
        painter: DashedLinePainter(
            spacing: spacing,
            strokeWidth: strokeWidth,
            color: color,
            strokeThickness: strokeThickness),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final double? strokeWidth;
  final double? spacing;
  final Color? color;
  final double? strokeThickness;

  DashedLinePainter({
    super.repaint,
    required this.strokeWidth,
    required this.spacing,
    required this.color,
    required this.strokeThickness,
  });
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = strokeWidth ?? 9, dashSpace = spacing ?? 5, startX = 0;
    final paint = Paint()
      ..color = color ?? Colors.grey
      ..strokeWidth = strokeThickness ?? 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
