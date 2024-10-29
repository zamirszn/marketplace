import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/ui/home/new_product_widget.dart';

class NewProductsCarousel extends StatelessWidget {
  const NewProductsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 30,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: NewProductWidget(
              product: testProductModel,
            ),
          );
        });
  }
}

// class NewProductsCarousel extends StatefulWidget {
//   const NewProductsCarousel({super.key});

//   @override
//   State<NewProductsCarousel> createState() => _NewProductsCarouselState();
// }

// class _NewProductsCarouselState extends State<NewProductsCarousel> {
//   int currentPage = 0;
//   Timer? timer;
//   PageController pageController =
//       PageController(viewportFraction: .5, initialPage: 999);

//   @override
//   void initState() {
//     startAutoScroll();
//     super.initState();
//   }

//   void startAutoScroll() {
//     timer = Timer.periodic(
//       const Duration(seconds: 4),
//       (timer) {
//         currentPage++;
//         pageController.animateToPage(currentPage,
//             duration: const Duration(seconds: 1), curve: Curves.easeOut);
//       },
//     );
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PageView.builder(
//         onPageChanged: (value) {
//           currentPage = value;
//         },
//         controller: pageController,
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           int imageIndex = index % testImages.length;
//           return AnimatedBuilder(
//             animation: pageController,
//             builder: (context, child) {
//               double value = 1.0;
//               if (pageController.position.haveDimensions) {
//                 value = (pageController.page! - index).abs().clamp(0.0, 1.0);
//               }
//               return Transform.scale(
//                 scale: 1.0 - value * 0.1,
//                 child: Opacity(
//                     opacity: 1.0 - value * 0.5,
//                     child: NewProductWidget(
//                         productName: "Product Name",
//                         productPrice: 50,
//                         discountPrice: 40,
//                         productImagePath: testImages[imageIndex])),
//               );
//             },
//           );
//         });
//   }
// }
