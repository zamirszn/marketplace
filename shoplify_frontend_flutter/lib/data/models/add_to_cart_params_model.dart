// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddToCartParamsModel {
  final String productId;
  final int quantity;

  AddToCartParamsModel({required this.productId, required this.quantity});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
    };
  }

  factory AddToCartParamsModel.fromMap(Map<String, dynamic> map) {
    return AddToCartParamsModel(
      productId: map['product_id'] as String,
      quantity: map['quantity'] as int,
    );
  }
}
