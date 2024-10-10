import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/presentation/widgets/market_item_widget.dart';

class PopularProductsCarousel extends StatefulWidget {
  const PopularProductsCarousel({super.key});

  @override
  State<PopularProductsCarousel> createState() =>
      _PopularProductsCarouselState();
}

class _PopularProductsCarouselState extends State<PopularProductsCarousel> {
  int currentPage = 0;
  Timer? timer;
  PageController pageController =
      PageController(viewportFraction: .5, initialPage: 999);

  @override
  void initState() {
    //add post framecallback to start auto scroll
    startAutoScroll();

    super.initState();
  }

  void startAutoScroll() {
    timer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        currentPage++;
        pageController.animateToPage(currentPage,
            duration: const Duration(seconds: 1), curve: Curves.easeOut);
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        onPageChanged: (value) {
          currentPage = value;
        },
        controller: pageController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          int imageIndex = index % testImages.length;
          return AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              double value = 1.0;
              if (pageController.position.haveDimensions) {
                value = (pageController.page! - index).abs().clamp(0.0, 1.0);
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
        });
  }
}
