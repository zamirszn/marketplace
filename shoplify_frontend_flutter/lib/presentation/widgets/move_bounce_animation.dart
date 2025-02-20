import 'package:flutter/material.dart';

class MoveAndBounceAnimation extends StatefulWidget {
  const MoveAndBounceAnimation(
      {super.key,
      required this.child,
      this.dx,
      this.dy,
      this.dx2,
      this.dy2,
      this.milliseconds});
  final Widget child;
  final double? dx;
  final double? dy;
  final double? dx2;
  final double? dy2;
  final int? milliseconds;

  @override
  State<MoveAndBounceAnimation> createState() => _MoveAndBounceAnimationState();
}

class _MoveAndBounceAnimationState extends State<MoveAndBounceAnimation>
    with TickerProviderStateMixin {
  AnimationController? bounceController;

  Animation? bounceAnimation;

  @override
  void initState() {
    startAnimation();
    super.initState();
  }

  @override
  void dispose() {
    bounceController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: bouncingWidgetContainer(),
    );
  }

  Widget bouncingWidgetContainer() {
    return Transform.translate(
      offset: bounceAnimation?.value,
      child: widget.child,
    );
  }

  void startAnimation() {
    bounceController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.milliseconds ?? 5000));
    bounceAnimation = Tween(
            begin: Offset(widget.dx ?? 10, widget.dy ?? 10),
            end: Offset(widget.dx2 ?? -10, widget.dy2 ?? 30))
        .animate(bounceController!);

    bounceController?.addListener(() => setState(() {}));
    bounceController?.forward();

    bounceController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bounceController?.reverse();
      } else if (status == AnimationStatus.dismissed) {
        bounceController?.forward(from: 0.0);
      }
    });
  }
}
