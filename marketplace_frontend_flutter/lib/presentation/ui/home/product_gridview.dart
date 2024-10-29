import 'package:flutter/material.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/ui/home/product_widget.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: testImages.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          mainAxisExtent: 250,
          crossAxisSpacing: AppSize.s10,
          mainAxisSpacing: AppSize.s10),
      itemBuilder: (context, index) {
        return ProductWidget(
          product: testProductModel,
        );
      },
    );
  }
}
