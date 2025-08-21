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
  final ProductCategory? category;
  final num? price;
  final num? discountedPrice;
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
    this.price,
    this.discountedPrice,
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
    num? price,
    num? discountedPrice,
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
        price: price ?? this.price,
        discountedPrice: discountedPrice ?? this.discountedPrice,
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
        category: json["category"] == null
            ? null
            : ProductCategory.fromMap(json["category"]),
        price: json['price'] != null
            ? num.tryParse(json['price'].toString())
            : null,
        discountedPrice: json['discounted_price'] != null
            ? num.tryParse(json['discounted_price'].toString())
            : null,
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
        "price": price,
        "discounted_price": discountedPrice,
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
