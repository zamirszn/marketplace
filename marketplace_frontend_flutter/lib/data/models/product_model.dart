// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:marketplace/data/models/product_category_model.dart';
import 'package:marketplace/domain/entities/product_entity.dart';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromMap(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ProductModel {
  final String? id;
  final String? name;
  final String? description;
  final bool? discount;
  final ProductCategoryModel? category;
  final double? oldPrice;
  final double? price;
  final String? slug;
  final int? inventory;
  final num? averageRating;

  final List<Image> images;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.category,
    this.oldPrice,
    this.discount,
    this.price,
    this.slug,
    this.inventory,
    this.averageRating,
    required this.images,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    ProductCategoryModel? category,
    double? oldPrice,
    double? price,
    bool? discount,
    String? slug,
    int? inventory,
    num? averageRating,
    List<Image>? images,
  }) => 
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        category: category ?? this.category,
        oldPrice: oldPrice ?? this.oldPrice,
        discount: discount ?? this.discount,
        price: price ?? this.price,
        slug: slug ?? this.slug,
        inventory: inventory ?? this.inventory,
        averageRating: averageRating ?? this.averageRating,
        images: images ?? this.images,
      );

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        discount: json["discount"],
        category: json["category"] == null
            ? null
            : ProductCategoryModel.fromMap(json["category"]),
        oldPrice: json["old_price"]?.toDouble(),
        price: json["price"]?.toDouble(),
        slug: json["slug"],
        inventory: json["inventory"],
        averageRating: json["average_rating"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category?.toMap(),
        "old_price": oldPrice,
        "discount": discount,
        "price": price,
        "slug": slug,
        "inventory": inventory,
        "average_rating": averageRating,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class Image {
  final int? id;
  final String? image;
  final String? product;

  Image({
    this.id,
    this.image,
    this.product,
  });

  Image copyWith({
    int? id,
    String? image,
    String? product,
  }) =>
      Image(
        id: id ?? this.id,
        image: image ?? this.image,
        product: product ?? this.product,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        image: json["image"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "product": product,
      };
}

extension ProductModelXModel on ProductModel {
  ProductModelEntity toEntity() {
    return ProductModelEntity(
        category: category,
        description: description,
        id: id,
        discount: discount,
        images: images,
        inventory: inventory,
        name: name,
        oldPrice: oldPrice,
        price: price,
        averageRating: averageRating,
        slug: slug);
  }
}
