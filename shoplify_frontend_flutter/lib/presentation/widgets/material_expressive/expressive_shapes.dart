import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:material_shapes/material_shapes.dart';

class AnimatedExpressiveShape extends StatefulWidget {
  final List<RoundedPolygon> shapes;
  final Widget? child;
  final Color? color;
  final double size;
  final Duration morphDuration;
  final bool autoStart;
  final SpringDescription? springDescription;
  final VoidCallback? onShapeChanged;

  const AnimatedExpressiveShape({
    super.key,
    required this.shapes,
    this.child,
    this.color,
    this.size = 200.0,
    this.morphDuration = const Duration(seconds: 1),
    this.autoStart = true,
    this.springDescription,
    this.onShapeChanged,
  }) : assert(shapes.length >= 2, 'Need at least 2 shapes to morph between');

  @override
  State<AnimatedExpressiveShape> createState() =>
      _AnimatedExpressiveShapeState();
}

class _AnimatedExpressiveShapeState extends State<AnimatedExpressiveShape>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<int> _morphIndex;
  late final List<Morph> _morphs;
  late final AnimationController _controller;
  Timer? _timer;
  late final SpringSimulation _springSimulation;

  @override
  void initState() {
    super.initState();

    _morphIndex = ValueNotifier(0);

    // Create morphs between consecutive shapes (including wrap-around)
    _morphs = <Morph>[];
    for (var i = 0; i < widget.shapes.length; i++) {
      _morphs.add(
        Morph(
          widget.shapes[i],
          widget.shapes[(i + 1) % widget.shapes.length],
        ),
      );
    }

    _controller = AnimationController.unbounded(vsync: this);

    // Setup spring simulation
    _springSimulation = SpringSimulation(
      widget.springDescription ??
          SpringDescription.withDampingRatio(
            ratio: 0.5,
            stiffness: 400,
            mass: 1,
          ),
      0,
      1,
      5,
      snapToEnd: true,
    );

    if (widget.autoStart) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      _timer = Timer.periodic(
        widget.morphDuration,
        (_) => _onAnimationDone(),
      );

      _controller
        ..value = 0
        ..animateWith(_springSimulation);
    });
  }

  void _onAnimationDone() {
    if (!mounted) return;

    _morphIndex.value = (_morphIndex.value + 1) % _morphs.length;
    widget.onShapeChanged?.call();

    _controller
      ..value = 0
      ..animateWith(_springSimulation);
  }

  @override
  void dispose() {
    _morphIndex.dispose();
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipPath(
        clipper: _AnimatedMorphClipper(
          morphs: _morphs,
          morphIndex: _morphIndex,
          progress: _controller,
        ),
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: widget.child ??
              Container(
                color: widget.color ?? Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }
}

// The animated clipper that handles the morphing
class _AnimatedMorphClipper extends CustomClipper<Path> {
  _AnimatedMorphClipper({
    required this.morphs,
    required this.morphIndex,
    required this.progress,
  }) : super(
          reclip: Listenable.merge([morphIndex, progress]),
        );

  final List<Morph> morphs;
  final ValueListenable<int> morphIndex;
  final Animation<double> progress;

  @override
  Path getClip(Size size) {
    final path = morphs[morphIndex.value].toPath(progress: progress.value);

    // Scale the path to fit the widget size
    final matrix = Matrix4.identity()..scale(size.width, size.height);
    return path.transform(matrix.storage);
  }

  @override
  bool shouldReclip(_AnimatedMorphClipper oldDelegate) {
    return oldDelegate.morphs != morphs ||
        oldDelegate.morphIndex != morphIndex ||
        oldDelegate.progress != progress;
  }
}

// Generic clipper that works with any RoundedPolygon from MaterialShapes
class MaterialShapeClipper extends CustomClipper<Path> {
  final RoundedPolygon shape;

  const MaterialShapeClipper(this.shape);

  @override
  Path getClip(Size size) {
    // Get the path from the RoundedPolygon
    final path = shape.toPath();

    // Scale the path to fit the widget size
    final matrix = Matrix4.identity()..scale(size.width, size.height);

    return path.transform(matrix.storage);
  }

  @override
  bool shouldReclip(covariant MaterialShapeClipper oldClipper) {
    return oldClipper.shape != shape;
  }
}

// Reusable widget for any MaterialShape
class MaterialShapeContainer extends StatelessWidget {
  final RoundedPolygon shape;
  final Widget? child;
  final Color? color;
  final double size;
  final Decoration? decoration;

  const MaterialShapeContainer({
    super.key,
    required this.shape,
    this.child,
    this.color,
    this.size = 200.0,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MaterialShapeClipper(shape),
      child: SizedBox(
        width: size,
        height: size,
        child: child ??
            Container(
              color: color ?? Theme.of(context).primaryColor,
              decoration: decoration,
            ),
      ),
    );
  }
}

// Convenience constructors for common shapes
class ExpressiveShapes {
  // All the shapes from your original list
  static Widget circle({
    Widget? child,
    Color? color,
    double size = 200.0,
    Decoration? decoration,
  }) =>
      MaterialShapeContainer(
        shape: MaterialShapes.circle,
        color: color,
        size: size,
        decoration: decoration,
        child: child,
      );

  static Widget square({
    Widget? child,
    Color? color,
    double size = 200.0,
    Decoration? decoration,
  }) =>
      MaterialShapeContainer(
        shape: MaterialShapes.square,
        color: color,
        size: size,
        decoration: decoration,
        child: child,
      );

  static Widget bun({
    Widget? child,
    Color? color,
    double size = 200.0,
    Decoration? decoration,
  }) =>
      MaterialShapeContainer(
        shape: MaterialShapes.bun,
        color: color,
        size: size,
        decoration: decoration,
        child: child,
      );

  static Widget heart({
    Widget? child,
    Color? color,
    double size = 200.0,
    Decoration? decoration,
  }) =>
      MaterialShapeContainer(
        shape: MaterialShapes.heart,
        color: color,
        size: size,
        decoration: decoration,
        child: child,
      );

  static Widget flower({
    Widget? child,
    Color? color,
    double size = 200.0,
    Decoration? decoration,
  }) =>
      MaterialShapeContainer(
        shape: MaterialShapes.flower,
        color: color,
        size: size,
        decoration: decoration,
        child: child,
      );

  static Widget star({
    Widget? child,
    Color? color,
    double size = 200.0,
    Decoration? decoration,
  }) =>
      MaterialShapeContainer(
        shape: MaterialShapes.burst,
        color: color,
        size: size,
        decoration: decoration,
        child: child,
      );

  static Widget diamond({
    Widget? child,
    Color? color,
    double size = 200.0,
    Decoration? decoration,
  }) =>
      MaterialShapeContainer(
        shape: MaterialShapes.diamond,
        color: color,
        size: size,
        decoration: decoration,
        child: child,
      );
}

// Example usage showcase
class MaterialShapeShowcase extends StatelessWidget {
  const MaterialShapeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Material Shapes Clipper')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Using Generic MaterialShapeContainer:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Generic usage
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  // Direct usage with any shape
                  MaterialShapeContainer(
                    shape: MaterialShapes.bun,
                    size: 100,
                    color: Colors.brown,
                  ),

                  MaterialShapeContainer(
                    shape: MaterialShapes.heart,
                    size: 100,
                    color: Colors.red,
                  ),

                  MaterialShapeContainer(
                    shape: MaterialShapes.flower,
                    size: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.purple],
                      ),
                    ),
                  ),

                  // With custom child content
                  MaterialShapeContainer(
                    shape: MaterialShapes.circle,
                    size: 100,
                    color: Colors.blue,
                    child: const Center(
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Text(
                'Using Convenience Constructors:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Convenience constructors
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  ExpressiveShapes.bun(
                    size: 100,
                    color: const Color(0xFFD2691E),
                  ),
                  ExpressiveShapes.heart(
                    size: 100,
                    child: const Center(
                      child: Text(
                        '❤️',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    color: Colors.pink.shade100,
                  ),
                  ExpressiveShapes.flower(
                    size: 100,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Colors.yellow, Colors.orange, Colors.red],
                        ),
                      ),
                    ),
                  ),
                  ExpressiveShapes.diamond(
                    size: 100,
                    child: Image.network(
                      'https://picsum.photos/200/200',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: const Icon(Icons.error, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Text(
                'Interactive Example:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Interactive button
              ExpressiveShapes.bun(
                size: 120,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bun tapped!')),
                      );
                    },
                    child: Container(
                      color: Colors.brown,
                      child: const Center(
                        child: Text(
                          'TAP ME',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Simple usage examples for quick reference
class QuickUsageExamples {
  // Just the bun (your original request)
  static Widget simpleBun() => ExpressiveShapes.bun(
        size: 150,
        color: Colors.brown,
      );

  // Any shape with custom content
  static Widget anyShapeWithContent() => MaterialShapeContainer(
        shape: MaterialShapes.heart, // Change this to any MaterialShape
        size: 150,
        color: Colors.red,
        child: const Center(
          child: Text(
            'Hello',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      );

  // Multiple shapes in a row
  static Widget multipleShapes() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ExpressiveShapes.circle(size: 80, color: Colors.blue),
          ExpressiveShapes.bun(size: 80, color: Colors.brown),
          ExpressiveShapes.heart(size: 80, color: Colors.red),
        ],
      );
}





// Rotating clipper where the shape rotates but content stays fixed
class RotatingShapeClipper extends CustomClipper<Path> {
  final RoundedPolygon shape;
  final double rotationAngle; // in radians
  
  const RotatingShapeClipper({
    required this.shape,
    required this.rotationAngle,
  });

  @override
  Path getClip(Size size) {
    // Get the base path from the shape
    final path = shape.toPath();
    
    // Create transformation matrix that:
    // 1. Scales to widget size
    // 2. Translates to center for rotation
    // 3. Rotates around center
    // 4. Translates back
    final matrix = Matrix4.identity()
      ..scale(size.width, size.height)
      ..translate(0.5, 0.5) // Move to center (in normalized coordinates)
      ..rotateZ(rotationAngle) // Rotate around Z-axis
      ..translate(-0.5, -0.5); // Move back from center
    
    return path.transform(matrix.storage);
  }

  @override
  bool shouldReclip(covariant RotatingShapeClipper oldClipper) {
    return oldClipper.shape != shape || 
           oldClipper.rotationAngle != rotationAngle;
  }
}

// Main widget: rotating shape clipper with fixed content
class RotatingMaterialShape extends StatefulWidget {
  final RoundedPolygon shape;
  final Widget? child;
  final Color? color;
  final double size;
  final Decoration? decoration;
  final Duration rotationDuration;
  final bool clockwise;
  final bool autoStart;
  final Curve curve;

  const RotatingMaterialShape({
    super.key,
    required this.shape,
    this.child,
    this.color,
    this.size = 200.0,
    this.decoration,
    this.rotationDuration = const Duration(seconds: 40),
    this.clockwise = true,
    this.autoStart = true,
    this.curve = Curves.linear,
  });

  @override
  State<RotatingMaterialShape> createState() => _RotatingMaterialShapeState();
}

class _RotatingMaterialShapeState extends State<RotatingMaterialShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.rotationDuration,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.clockwise ? 2 * math.pi : -2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.autoStart) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, _) {
        return ClipPath(
          clipper: RotatingShapeClipper(
            shape: widget.shape,
            rotationAngle: _rotationAnimation.value,
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: widget.child ?? Container(
              color: widget.color ?? Theme.of(context).primaryColor,
              decoration: widget.decoration,
            ),
          ),
        );
      },
    );
  }
}
