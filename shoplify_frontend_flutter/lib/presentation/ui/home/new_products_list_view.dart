import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/ui/home/new_product_widget.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/retry_button.dart';

class NewProductsListView extends StatelessWidget {
  const NewProductsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) => ProductBloc()..add(GetNewProductsEvent()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is NewProductLoading) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ProductWidgetSkeleton());
                });
          } else if (state is NewProductEmpty) {
            return const Center(
                child: EmptyWidget(
              message: AppStrings.noPopularProducts,
            ));
          } else if (state is NewProductFailure) {
            return Center(
              child: RetryButton(
                message: state.message,
                retry: () {
                  context.read<ProductBloc>().add(GetNewProductsEvent());
                },
              ),
            );
          } else if (state is NewProductSuccess) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.newProducts.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  ProductModelEntity newProducts = state.newProducts[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NewProductWidget(
                      product: newProducts,
                    ),
                  );
                });
          }

          return const SizedBox();
        },
      ),
    );
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
