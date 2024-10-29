import 'package:flutter/material.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/data/models/product_model.dart';
import 'package:marketplace/presentation/ui/cart/cart_item_widget.dart';

class CartItemListview extends StatelessWidget {
  const CartItemListview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 3,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return CartItemWidget(
          product: testProductModel,
        );
      },
    );
  }
}
