import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/widgets/back_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductImagePage extends StatefulWidget {
  const ProductImagePage({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<ProductImagePage> createState() => _ProductImagePageState();
}

class _ProductImagePageState extends State<ProductImagePage>
    with TickerProviderStateMixin {
  TransformationController _transformationController =
      TransformationController();

  double maxScale = 2.5;
  double minScale = 1.0;

  double get _scale => _transformationController.value.row0.x;
  bool enablePageView = true;

  Offset? _doubleTapLocalPosition;

  AnimationController? _animationController;
  Animation<Matrix4>? _animation;

  AnimationController? _dragAnimationController;

  /// Drag offset animation controller.
  Animation<Offset>? _dragAnimation;
  Offset? _dragOffset;
  Offset? _previousPosition;

  bool _enableDrag = true;

  late final AnimationController _hidePercentController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );

  late final Animation<double> _aniHidePercent =
      Tween<double>(begin: 1.0, end: 0.0).animate(_hidePercentController);
  bool _isTapScreen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        _transformationController.value =
            _animation?.value ?? Matrix4.identity();
      });

    /// initial drag animation controller
    _dragAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addStatusListener((status) {
        _onAnimationEnd(status);
      });
    _dragAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_dragAnimationController!);

    /// initial hide bar animation
    _hidePercentController.addListener(() {
      if (_hidePercentController.status == AnimationStatus.dismissed) {
        _delayHideMenu();
      }
    });
  }

  _checkShowBar() {
    if (_aniHidePercent.value <= 0) {
      _hidePercentController.reverse();
    } else {
      _hidePercentController.forward();
    }
  }

  Future _delayHideMenu() async {
    if (_isTapScreen) return;
    await _hidePercentController.forward();
  }

  void _onAnimationEnd(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _dragAnimationController?.reset();
      setState(() {
        _dragOffset = null;
        _previousPosition = null;
      });
    }
  }

  void _onDragStart(ScaleStartDetails scaleDetails) {
    _previousPosition = scaleDetails.focalPoint;
  }

  void _onDragUpdate(ScaleUpdateDetails scaleUpdateDetails) {
    final currentPosition = scaleUpdateDetails.focalPoint;
    final previousPosition = _previousPosition ?? currentPosition;

    final newY =
        (_dragOffset?.dy ?? 0.0) + (currentPosition.dy - previousPosition.dy);
    _previousPosition = currentPosition;
    if (_enableDrag) {
      setState(() {
        _dragOffset = Offset(0, newY);
      });
    }
  }

  /// Handles the end of an over-scroll drag event.
  ///
  /// If [scaleEndDetails] is not null, it checks if the drag offset exceeds a certain threshold
  /// and if the velocity is fast enough to trigger a pop action. If so, it pops the current route.
  void _onOverScrollDragEnd(ScaleEndDetails? scaleEndDetails) {
    if (_dragOffset == null) return;
    final dragOffset = _dragOffset!;

    final screenSize = MediaQuery.of(context).size;

    if (scaleEndDetails != null) {
      if (dragOffset.dy.abs() >= screenSize.height / 3) {
        Navigator.of(context, rootNavigator: true).pop();
        return;
      }
      final velocity = scaleEndDetails.velocity.pixelsPerSecond;
      final velocityY = velocity.dy;

      /// Make sure the velocity is fast enough to trigger the pop action
      /// Prevent mistake zoom in fast and drag => check dragOffset.dy.abs() > thresholdOffsetYToEnablePop
      const thresholdOffsetYToEnablePop = 75.0;
      const thresholdVelocityYToEnablePop = 200.0;
      if (velocityY.abs() > thresholdOffsetYToEnablePop &&
          dragOffset.dy.abs() > thresholdVelocityYToEnablePop &&
          _enableDrag) {
        Navigator.of(context, rootNavigator: true).pop();
        return;
      }
    }

    /// Reset position to center of the screen when the drag is canceled.
    setState(() {
      _dragAnimation = Tween<Offset>(
        begin: Offset(0.0, dragOffset.dy),
        end: const Offset(0.0, 0.0),
      ).animate(_dragAnimationController!);
      _dragOffset = const Offset(0.0, 0.0);
      _dragAnimationController?.forward();
    });
  }

  _onDoubleTap() {
    /// clone matrix4 current
    Matrix4 matrix = _transformationController.value.clone();

    /// Get the current value to see if the image is in zoom out or zoom in state
    final double currentScale = matrix.row0.x;

    /// Suppose the current state is zoom out
    double targetScale = minScale;

    /// Determines the state after a double tap action exactly
    if (currentScale <= minScale) {
      targetScale = maxScale;
    }

    /// calculate new offset of double tap
    final double offSetX = targetScale == minScale
        ? 0.0
        : -_doubleTapLocalPosition!.dx * (targetScale - 1);
    final double offSetY = targetScale == minScale
        ? 0.0
        : -_doubleTapLocalPosition!.dy * (targetScale - 1);

    matrix = Matrix4.fromList([
      targetScale,
      matrix.row1.x,
      matrix.row2.x,
      matrix.row3.x,
      matrix.row0.y,
      targetScale,
      matrix.row2.y,
      matrix.row3.y,
      matrix.row0.z,
      matrix.row1.z,
      targetScale,
      matrix.row3.z,
      offSetX,
      offSetY,
      matrix.row2.w,
      matrix.row3.w
    ]);

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: matrix,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(_animationController!),
    );
    _animationController?.forward(from: 0);
  }

  @override
  void dispose() {
    _hidePercentController.dispose();
    _dragAnimationController?.removeStatusListener(_onAnimationEnd);
    _dragAnimationController?.dispose();
    _animationController?.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(AppPadding.p10),
          child: GoBackButton(),
        ),
        title: Text(
          "Image",
          style: getRegularStyle(
              font: FontConstants.ojuju, fontSize: FontSize.s20),
        ),
      ),
      backgroundColor: ColorManager.primary,
      body: SizedBox(
        height: deviceHeight(context),
        child: AnimatedBuilder(
            animation: _dragAnimation!,
            builder: (context, _) {
              Offset finalOffset = _dragOffset ?? const Offset(0.0, 0.0);
              if (_dragAnimation?.status == AnimationStatus.forward)
                finalOffset = _dragAnimation!.value;
              return Transform.translate(
                offset: finalOffset,
                child: _,
              );
            },
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: minScale,
              maxScale: maxScale,
              onInteractionUpdate: (details) {
                _onDragUpdate(details);
                if (_scale == 1.0) {
                  enablePageView = true;
                  _enableDrag = true;
                } else {
                  enablePageView = false;
                  _enableDrag = false;
                }
                setState(() {});
              },
              onInteractionEnd: (details) {
                if (_enableDrag) {
                  _onOverScrollDragEnd(details);
                }
              },
              onInteractionStart: (details) {
                if (_enableDrag) {
                  _onDragStart(details);
                }
              },
              child: Center(
                child: GestureDetector(
                  onDoubleTapDown: (TapDownDetails details) {
                    _doubleTapLocalPosition = details.localPosition;
                  },
                  onDoubleTap: _onDoubleTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.s10),
                    child: CachedNetworkImage(
                      alignment: Alignment.center,
                      imageUrl: widget.imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: ColorManager.white,
                        height: AppSize.s100,
                        width: AppSize.s100,
                      ),
                      errorWidget: (context, url, error) => Skeletonizer(
                          child: Container(
                        color: ColorManager.white,
                        height: AppSize.s100,
                        width: AppSize.s100,
                      )),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
