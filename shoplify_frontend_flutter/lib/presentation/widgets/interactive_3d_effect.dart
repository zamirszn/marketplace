import 'package:flutter/material.dart';
import 'dart:math' as math;

class Interactive3DEffect extends StatefulWidget {
  const Interactive3DEffect({super.key, required this.child});
  final Widget child;

  @override
  Interactive3DEffectState createState() => Interactive3DEffectState();
}

class Interactive3DEffectState extends State<Interactive3DEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationX;
  late Animation<double> _animationY;
  double _angleX = 0;
  double _angleY = 0;

  final double _maxAngle = math.pi / 12;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animationX = Tween<double>(begin: 0, end: 0).animate(_controller);
    _animationY = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _angleX =
          (_angleX + details.delta.dy * 0.01).clamp(-_maxAngle, _maxAngle);
      _angleY =
          (_angleY - details.delta.dx * 0.01).clamp(-_maxAngle, _maxAngle);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _animationX = Tween<double>(begin: _angleX, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _animationY = Tween<double>(begin: _angleY, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward(from: 0);

    _animationX.addListener(() {
      setState(() {
        _angleX = _animationX.value;
        _angleY = _animationY.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(_angleX) // rotate around X axis
            ..rotateY(_angleY), // rotate around Y axis
          child: widget.child),
    );
  }
}
