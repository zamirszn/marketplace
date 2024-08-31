import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/presentation/resources/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/shared/color_extractor_widget.dart';
import 'package:marketplace/presentation/shared/market_item_widget.dart';
import 'package:marketplace/presentation/shared/preload_pageview.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PopularProductsCarousel extends StatefulWidget {
  const PopularProductsCarousel({super.key});

  @override
  State<PopularProductsCarousel> createState() =>
      _PopularProductsCarouselState();
}

class _PopularProductsCarouselState extends State<PopularProductsCarousel> {
  PreloadPageController? pageController;
  int currentPage = 0;
  Timer? timer;

  double scaleFactor = .5;
  @override
  void initState() {
    pageController =
        PreloadPageController(viewportFraction: scaleFactor, initialPage: 999);

    //add post framecallback to start auto scroll
    startAutoScroll();

    super.initState();
  }

  void startAutoScroll() {
    timer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        currentPage++;
        pageController?.animateToPage(currentPage,
            duration: const Duration(seconds: 1), curve: Curves.easeOut);
      },
    );
  }

  @override
  void dispose() {
    print("dispose");
    pageController?.dispose();
    timer?.cancel();
    super.dispose();
  }

  final popularProductKey = const Key('popularProductKey');

  void _handleVisibilityChanged(VisibilityInfo info) {
    // performance improvement , this method pauses page view infinite animation when the widget is not in the viewport
    if (info.visibleFraction < 0.2) {
      print("pausing animation");
      timer?.cancel();
    } else if (timer != null && !timer!.isActive) {
      print("starting animation");

      startAutoScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: popularProductKey,
      onVisibilityChanged: _handleVisibilityChanged,
      child: PreloadPageView.builder(
          preloadPagesCount: 3,
          onPageChanged: (value) {
            currentPage = value;
          },
          controller: pageController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            int imageIndex = index % testImages.length;
            return AnimatedBuilder(
              animation: pageController!,
              builder: (context, child) {
                double value = 1.0;
                if (pageController!.position.haveDimensions) {
                  value = (pageController!.page! - index).abs().clamp(0.0, 1.0);
                }
                return Transform.scale(
                  scale: 1.0 - value * 0.2,
                  child: Opacity(
                      opacity: 1.0 - value * 0.5,
                      child: MarketItemWidget(
                          shouldExtractColor: false,
                          productImagePath: testImages[imageIndex])),
                );
              },
            );
          }),
    );
  }
}
