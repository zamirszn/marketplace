// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReviewParamModel {
  final String productId;

  ReviewParamModel({required this.productId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
    };
  }

  factory ReviewParamModel.fromMap(Map<String, dynamic> map) {
    return ReviewParamModel(
      productId: map['productId'] as String,
    );
  }
}
