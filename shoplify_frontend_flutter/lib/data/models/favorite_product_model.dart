import 'dart:convert';

import 'package:shoplify/data/models/product_model.dart';

// TODO: move all models to response model
FavoriteProductsResponseModel favoriteProductsFromMap(String str) =>
    FavoriteProductsResponseModel.fromMap(json.decode(str));

String favoriteProductsToMap(FavoriteProductsResponseModel data) =>
    json.encode(data.toMap());

class FavoriteProductsResponseModel {
  final int? count;
  final String? next;
  final String? previous;
  final List<FavoriteProductResult>? results;

  FavoriteProductsResponseModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  FavoriteProductsResponseModel copyWith({
    int? count,
    String? next,
    dynamic previous,
    List<FavoriteProductResult>? results,
  }) =>
      FavoriteProductsResponseModel(
        count: count ?? this.count,
        next: next ?? this.next,
        previous: previous ?? this.previous,
        results: results ?? this.results,
      );

  factory FavoriteProductsResponseModel.fromMap(Map<String, dynamic> json) =>
      FavoriteProductsResponseModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<FavoriteProductResult>.from(
                json["results"]!.map((x) => FavoriteProductResult.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toMap())),
      };
}

class FavoriteProductResult {
  final int? id;
  final Product? product;
  final DateTime? createdAt;
  final int? owner;

  FavoriteProductResult({
    this.id,
    this.product,
    this.createdAt,
    this.owner,
  });

  FavoriteProductResult copyWith({
    int? id,
    Product? product,
    DateTime? createdAt,
    int? owner,
  }) =>
      FavoriteProductResult(
        id: id ?? this.id,
        product: product ?? this.product,
        createdAt: createdAt ?? this.createdAt,
        owner: owner ?? this.owner,
      );

  factory FavoriteProductResult.fromMap(Map<String, dynamic> json) =>
      FavoriteProductResult(
        id: json["id"],
        product:
            json["product"] == null ? null : Product.fromMap(json["product"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        owner: json["owner"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "product": product?.toMap(),
        "created_at": createdAt?.toIso8601String(),
        "owner": owner,
      };
}
