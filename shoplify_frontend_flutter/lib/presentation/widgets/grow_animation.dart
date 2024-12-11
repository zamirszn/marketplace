import 'package:flutter/cupertino.dart';

class GrowAnimation extends StatefulWidget {
  const GrowAnimation({
    super.key,
    required this.child,
    this.milliseconds,
  });
  final Widget child;
  final int? milliseconds;

  @override
  State<GrowAnimation> createState() => _GrowAnimationState();
}

class _GrowAnimationState extends State<GrowAnimation>
    with TickerProviderStateMixin {
  AnimationController? growController;
  Animation? growAnimation;
  double? scale;

  @override
  void initState() {
    startAnimation();
    super.initState();
  }

  @override
  void dispose() {
    growController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scale = 1 - growController!.value;
    return Container(
      child: growWidget(),
    );
  }

  Widget growWidget() {
    return AnimatedBuilder(
      animation: growController!,
      builder: (context, child) {
        return Transform.scale(
          scale: scale,
          child: widget.child,
        );
      },
    );
  }

  void startAnimation() {
    growController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.milliseconds ?? 4000),
        lowerBound: 0.0,
        upperBound: 0.09);
    growAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: growController!, curve: Curves.easeInOutQuart));
    growController?.addListener(() => setState(() {}));
    growController?.forward();
    growController?.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await growController?.reverse();
      } else if (status == AnimationStatus.dismissed) {
        growController?.forward(from: 0.0);
      }
    });
  }
}
