import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';

class CookieImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CookieImage({
    required this.imageUrl,
    this.size = 100,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const ScalloppedPolygonClipper(
        bumpIntensity: .20,
      ),
      child: SizedBox(
        height: size,
        width: size,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: size,
          width: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: ColorManager.lightGrey,
            height: size,
            width: size,
          ),
          errorWidget: (context, url, error) => Container(
            color: ColorManager.lightGrey,
            height: size,
            width: size,
            child: const Icon(Iconsax.warning_2),
          ),
        ),
      ),
    );
  }
}

class ScalloppedPolygonClipper extends CustomClipper<Path> {
  /// Number of sides for the polygon
  final int sides;

  /// How pronounced the bumps are (0.0 = no bumps, 1.0 = very pronounced)
  final double bumpIntensity;

  /// Controls the smoothness of the curves (0.0 = sharp, 1.0 = very smooth)
  final double curveSmoothness;

  /// Rotation angle in radians (0.0 = top vertex at 12 o'clock)
  final double rotationAngle;

  /// Whether to invert the bumps (make them go inward instead of outward)
  final bool invertBumps;

  const ScalloppedPolygonClipper({
    this.sides = 9,
    this.bumpIntensity = 0.25,
    this.curveSmoothness = 0.7,
    this.rotationAngle = -pi / 2,
    this.invertBumps = false,
  })  : assert(sides >= 3, 'Polygon must have at least 3 sides'),
        assert(bumpIntensity >= 0.0 && bumpIntensity <= 1.0,
            'Bump intensity must be between 0.0 and 1.0'),
        assert(curveSmoothness >= 0.0 && curveSmoothness <= 1.0,
            'Curve smoothness must be between 0.0 and 1.0');

  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = min(size.width, size.height) / 2;

    // Calculate the angle between each vertex
    final angleStep = 2 * pi / sides;

    // Calculate radius adjustments based on bump intensity
    final bumpRadius = baseRadius * bumpIntensity;
    final mainRadius = baseRadius * (1.0 - bumpIntensity * 0.3);
    final bumpDirection = invertBumps ? -1.0 : 1.0;

    for (int i = 0; i < sides; i++) {
      final currentAngle = rotationAngle + (i * angleStep);
      final nextAngle = rotationAngle + ((i + 1) * angleStep);

      if (i == 0) {
        // Start from the first vertex
        final startX = center.dx + mainRadius * cos(currentAngle);
        final startY = center.dy + mainRadius * sin(currentAngle);
        path.moveTo(startX, startY);
      }

      // Calculate the angle for the middle of the current side
      final sideAngle = currentAngle + (angleStep / 2);

      // Calculate control points for the curved bump
      final controlAngleOffset = angleStep * (0.5 - curveSmoothness * 0.3);
      final controlAngle1 = currentAngle + controlAngleOffset;
      final controlAngle2 = nextAngle - controlAngleOffset;

      // Control point distances from center
      final controlRadius =
          mainRadius + (bumpRadius * curveSmoothness * bumpDirection);

      final control1X = center.dx + controlRadius * cos(controlAngle1);
      final control1Y = center.dy + controlRadius * sin(controlAngle1);

      final control2X = center.dx + controlRadius * cos(controlAngle2);
      final control2Y = center.dy + controlRadius * sin(controlAngle2);

      // End point (next vertex)
      final endX = center.dx + mainRadius * cos(nextAngle);
      final endY = center.dy + mainRadius * sin(nextAngle);

      // Create the curved bump using cubic bezier
      path.cubicTo(
          control1X,
          control1Y, // First control point
          control2X,
          control2Y, // Second control point
          endX,
          endY // End point
          );
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant ScalloppedPolygonClipper oldClipper) {
    return oldClipper.sides != sides ||
        oldClipper.bumpIntensity != bumpIntensity ||
        oldClipper.curveSmoothness != curveSmoothness ||
        oldClipper.rotationAngle != rotationAngle ||
        oldClipper.invertBumps != invertBumps;
  }
}
