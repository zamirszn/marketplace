// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:shoplify/domain/entities/product_category_entity.dart';

class ProductCategoryModel {
  final String title;
  final String categoryId;

  ProductCategoryModel({required this.title, required this.categoryId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'category_id': categoryId,
    };
  }

  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoryModel(
      title: map['title'] as String,
      categoryId: map['category_id'] as String,
    );
  }
}

extension ProductCategoryXModel on ProductCategoryModel {
  ProductCategoryEntity toEntity() {
    return ProductCategoryEntity(categoryId: categoryId, title: title);
  }
}
