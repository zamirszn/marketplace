import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/presentation/all_products/bloc/all_products_bloc.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

class CoverFlowCarousel extends StatelessWidget {
  const CoverFlowCarousel({super.key, required this.productImages});
  final List<ProductImage> productImages;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _coverFlowStyle,
      builder: (context, value, child) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CoverFlowCarouselView(
                style: value,
                productImages: productImages,
              ),
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
    required this.productImages,
  });

  final CoverFlowStyle style;
  final List<ProductImage> productImages;

  @override
  State<CoverFlowCarouselView> createState() => _CoverFlowCarouselViewState();
}

class _CoverFlowCarouselViewState extends State<CoverFlowCarouselView> {
  PageController? _pageController;
  final _maxHeight = 250.0;
  final _minItemWidth = 40.0;
  final _spacing = 5.0;
  double _currentPageIndex = 0;

  @override
  void initState() {
    _pageController = PageController();
    _pageController?.addListener(() {
      setState(() {
        _currentPageIndex = _pageController?.page ?? 0;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateToLastAndBack();
    });

    super.initState();
  }

  Future<void> _animateToLastAndBack() async {
    if (widget.productImages.isEmpty) {
      return;
    }

    // Check if PageController is properly attached to a PageView
    if (_pageController == null ||
        !_pageController!.hasClients ||
        _pageController!.positions.isEmpty) {
      return;
    }

    try {
      // Animate from the first to the last page
      await _pageController!.animateToPage(
        widget.productImages.length - 1,
        duration: const Duration(milliseconds: 1300),
        curve: Curves.linear,
      );

      // Animate back to the first page
      await _pageController!.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    } catch (e) {
      // Handle any animation errors gracefully
      debugPrint('Animation error: $e');
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
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
              children: widget.productImages.asMap().entries.map((item) {
                final currentIndex = _currentPageIndex - item.key;
                return Positioned(
                  left: _getItemPosition(currentIndex, screenWidth) +
                      (_spacing / 2),
                  top: 0,
                  child: _CoverFlowPositionedItem(
                    imagePath: item.value.image,
                    index: currentIndex,
                    absIndex: currentIndex.abs(),
                    size: Size(screenWidth, _maxHeight),
                    minItemWidth: _minItemWidth,
                    maxItemWidth: screenWidth / 2,
                    spacing: _spacing,
                    style: widget.style,
                  ),
                );
              }).toList(),
            ),
          ),
          PageView.builder(
            hitTestBehavior: HitTestBehavior.translucent,
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            itemBuilder: (context, index) => const SizedBox.shrink(),
            itemCount: widget.productImages.length,
          ),
        ],
      ),
    );
  }

  double _getItemPosition(double index, double screenWidth) {
    final centerPosition = screenWidth / 2;
    final maxItemWidth = screenWidth / 2;
    final mainPosition = centerPosition - (maxItemWidth / 2);
    if (index == 0) return mainPosition;

    final absIndex = index.abs();
    final diffPosition = absIndex <= 1.0
        ? ((index > 0 ? _minItemWidth : maxItemWidth) * absIndex)
        : ((index > 0 ? (absIndex - 1) : (absIndex - 2)) * _minItemWidth);

    final leftPosition =
        absIndex <= 1 ? mainPosition : (mainPosition - _minItemWidth);
    final rightPosition = absIndex <= 1
        ? mainPosition
        : mainPosition + (maxItemWidth + _minItemWidth);

    return index > 0
        ? leftPosition - diffPosition
        : rightPosition + diffPosition;
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
  final String? imagePath;
  final double index;
  final double absIndex;
  final Size size;
  final double minItemWidth;
  final double maxItemWidth;
  final double spacing;
  final CoverFlowStyle style;

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
    final colorScheme = Theme.of(context).colorScheme;

    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: _calculateItemWidth,
        height: size.height,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (imagePath != null) {
              context
                  .read<AllProductsBloc>()
                  .add(SetViewProductImageUrl(imageUrl: imagePath!));
              goPush(
                context,
                Routes.productImagePage,
              );
            }
          },
          child: CachedNetworkImage(
            imageUrl: imagePath ?? "",
            height: AppSize.s120,
            fit: BoxFit.cover,
            placeholder: (context, url) => Skeletonizer(
                child: Container(
              color: ColorManager.white,
              height: AppSize.s100,
              width: AppSize.s100,
            )),
            errorWidget: (context, url, error) => Container(
              color: colorScheme.error,
              height: AppSize.s100,
              width: AppSize.s100,
            ),
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

    // Remove all positioning logic - just return the child
    return child;
  }
}
