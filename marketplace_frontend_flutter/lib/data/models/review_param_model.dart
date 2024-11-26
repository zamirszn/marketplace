// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReviewParamModel {
  final String productId;
  final int? page;
  String? ordering;
  num? rating;

  ReviewParamModel({
    required this.productId,
    this.page,
    this.ordering,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'ordering': ordering,
      'rating': rating,
      if (page != null) 'page': page,
    };
  }

  factory ReviewParamModel.fromMap(Map<String, dynamic> map) {
    return ReviewParamModel(
      productId: map['productId'] as String,
      ordering: map['ordering'] as String,
      rating: map['rating'] as num,
      page: map['page'] != null ? map['page'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewParamModel.fromJson(String source) =>
      ReviewParamModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
