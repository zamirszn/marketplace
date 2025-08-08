import 'dart:math' as math;

import 'package:flutter/material.dart';

class Flip3DTransition extends StatelessWidget {
  final Widget child;
  final Widget nextPage;
  final Animation<double> animation;

  const Flip3DTransition({
    super.key,
    required this.child,
    required this.nextPage,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final rotateAnim = Tween(begin: 0.0, end: math.pi).animate(animation);
        return Transform(
          alignment: AlignmentDirectional.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-rotateAnim.value),
          child: animation.value <= 0.05 ? this.child : nextPage,
        );
      },
    );
  }
}

class Flip3DPage extends StatefulWidget {
  final Widget currentPage;
  final Widget nextPage;

  const Flip3DPage({
    super.key,
    required this.currentPage,
    required this.nextPage,
  });

  @override
  Flip3DPageState createState() => Flip3DPageState();
}

class Flip3DPageState extends State<Flip3DPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
      // curve: Curves.easeInOutQuart,
      // curve: Curves.easeInBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onLongPress: _flip,
          child: Flip3DTransition(
            animation: _animation,
            nextPage: widget.nextPage,
            child: widget.currentPage,
          ),
        ),
      ),
    );
  }
}
