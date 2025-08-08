import 'dart:convert';

import 'package:shoplify/core/constants/api_urls.dart';
import 'package:shoplify/data/models/product_category_model.dart';

List<Product> productModelFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromMap(x)));

String productModelToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Product {
  final String? id;
  final String? name;
  final String? description;
  final bool? discount;
  final ProductCategory? category;
  final double? oldPrice;
  final double? price;
  final String? slug;
  final int? inventory;
  final num? averageRating;
  final num? reviewsLength;
  final bool? isFavorite;

  final List<ProductImage> images;

  Product({
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
    this.reviewsLength,
    this.isFavorite,
    required this.images,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    ProductCategory? category,
    double? oldPrice,
    double? price,
    bool? discount,
    String? slug,
    int? inventory,
    num? averageRating,
    num? reviewsLength,
    List<ProductImage>? images,
    bool? isFavorite,
  }) =>
      Product(
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
        reviewsLength: reviewsLength ?? this.reviewsLength,
        images: images ?? this.images,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        discount: json["discount"],
        category: json["category"] == null
            ? null
            : ProductCategory.fromMap(json["category"]),
        oldPrice: json["old_price"]?.toDouble(),
        price: json["price"]?.toDouble(),
        slug: json["slug"],
        inventory: json["inventory"],
        averageRating: json["average_rating"],
        reviewsLength: json["reviews_length"],
        isFavorite: json["is_favorite"],
        images: List<ProductImage>.from(
            json["images"].map((x) => ProductImage.fromJson(x))),
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
        "reviews_length": reviewsLength,
        "is_favorite": isFavorite,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class ProductImage {
  final int? id;
  final String? image;
  final String? product;

  ProductImage({
    this.id,
    this.image,
    this.product,
  });

  ProductImage copyWith({
    int? id,
    String? image,
    String? product,
  }) =>
      ProductImage(
        id: id ?? this.id,
        image: image ?? this.image,
        product: product ?? this.product,
      );

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json["id"],
        // TODO: remove before release only for testing purposes
        // image: json["image"],
        image: ApiUrls.baseUrl + json["image"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "product": product,
      };
}
