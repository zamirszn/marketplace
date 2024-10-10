import 'package:flutter/material.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';

enum CoverFlowStyle {
  none,
  scale,
  opacity,
  both;

  bool get isOpacity => this == CoverFlowStyle.opacity;
  bool get isScale => this == CoverFlowStyle.scale;
  bool get isBoth => this == CoverFlowStyle.both;
}

final _coverFlowStyle = ValueNotifier<CoverFlowStyle>(CoverFlowStyle.both);

class CoverFlowCarouselPage extends StatelessWidget {
  const CoverFlowCarouselPage({super.key});

  static PageRoute route() =>
      MaterialPageRoute(builder: (context) => const CoverFlowCarouselPage());

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _coverFlowStyle,
      builder: (context, value, child) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CoverFlowCarouselView(style: value),
            ],
          ),
        );
      },
    );
  }
}

class CoverFlowCarouselView extends StatefulWidget {
  const CoverFlowCarouselView({
    super.key,
    this.style = CoverFlowStyle.none,
  });

  final CoverFlowStyle style;

  @override
  State<CoverFlowCarouselView> createState() => _CoverFlowCarouselViewState();
}

class _CoverFlowCarouselViewState extends State<CoverFlowCarouselView> {
  late PageController _pageController;
  final _maxHeight = 250.0;
  final _minItemWidth = 40.0;
  double _currentPageIndex = 0;
  final _spacing = 10.0;
  final _images = [
    ImageAsset.atm,
    ImageAsset.cart,
    ImageAsset.cart2,
    ImageAsset.coin,
    ImageAsset.megaphone,
    ImageAsset.paperbag,
  ];

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _currentPageIndex.toInt(),
    );
    _pageController.addListener(_pageControllerListener);
    super.initState();
  }

  void _pageControllerListener() {
    setState(() {
      _currentPageIndex = _pageController.page ?? 0;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageControllerListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = deviceWidth(context);
    return SizedBox(
      height: _maxHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Stack(
              children: _images.asMap().entries.map((item) {
                final currentIndex = _currentPageIndex - item.key;
                return _CoverFlowPositionedItem(
                  imagePath: item.value,
                  index: currentIndex,
                  absIndex: currentIndex.abs(),
                  size: Size(screenWidth, _maxHeight),
                  minItemWidth: _minItemWidth,
                  maxItemWidth: screenWidth / 2,
                  spacing: _spacing,
                  style: widget.style,
                );
              }).toList(),
            ),
          ),
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) => const SizedBox.expand(),
              itemCount: _images.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverFlowPositionedItem extends StatelessWidget {
  const _CoverFlowPositionedItem({
    required this.imagePath,
    required this.index,
    required this.absIndex,
    required this.size,
    required this.minItemWidth,
    required this.maxItemWidth,
    required this.spacing,
    required this.style,
  });
  final String imagePath;
  final double index;
  final double absIndex;
  final Size size;
  final double minItemWidth;
  final double maxItemWidth;
  final double spacing;
  final CoverFlowStyle style;

  double get _getItemPosition {
    final centerPosition = size.width / 2;
    final mainPosition = centerPosition - (maxItemWidth / 2);
    if (index == 0) return mainPosition;
    return _calculateNewMainPosition(mainPosition);
  }

  double get _calculateItemWidth {
    final diffWidth = maxItemWidth - minItemWidth;
    final newMaxItemWidth = maxItemWidth - (diffWidth * absIndex);
    return (absIndex < 1 ? newMaxItemWidth : minItemWidth) - spacing;
  }

  double get _getScaleValue => 1 - (0.15 * absIndex);

  double get _getOpacityValue {
    return (1 - (0.2 * absIndex)).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: _calculateItemWidth,
        height: size.height,
        child: ColoredBox(
          color: ColorManager.color6,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    child = AnimatedScale(
      scale: style.isScale || style.isBoth ? _getScaleValue : 1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.ease,
      child: child,
    );

    child = AnimatedOpacity(
      opacity: style.isOpacity || style.isBoth ? _getOpacityValue : 1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.ease,
      child: child,
    );

    child = Padding(
      padding: EdgeInsets.only(left: spacing / 2),
      child: child,
    );

    return Transform.translate(
      offset: Offset(_getItemPosition, 0),
      child: child,
    );
  }

  double _calculateLeftPosition(double mainPosition) {
    return absIndex <= 1 ? mainPosition : (mainPosition - minItemWidth);
  }

  double _calculateRightPosition(double mainPosition) {
    final totalItemWidth = maxItemWidth + minItemWidth;
    return absIndex <= 1 ? mainPosition : mainPosition + totalItemWidth;
  }

  double _calculateRightAndLeftDiffPosition() {
    return absIndex <= 1.0
        ? ((index > 0 ? minItemWidth : maxItemWidth) * absIndex)
        : ((index > 0 ? (absIndex - 1) : (absIndex - 2)) * minItemWidth);
  }

  double _calculateNewMainPosition(double mainPosition) {
    final diffPosition = _calculateRightAndLeftDiffPosition();
    final leftPosition = _calculateLeftPosition(mainPosition);
    final rightPosition = _calculateRightPosition(mainPosition);
    return index > 0
        ? leftPosition - diffPosition
        : rightPosition + diffPosition;
  }
}
