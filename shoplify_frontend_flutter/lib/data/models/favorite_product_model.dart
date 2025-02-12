
import 'dart:convert';

import 'package:shoplify/data/models/product_model.dart';

FavoriteProducts favoriteProductsFromMap(String str) => FavoriteProducts.fromMap(json.decode(str));

String favoriteProductsToMap(FavoriteProducts data) => json.encode(data.toMap());

class FavoriteProducts {
    final int? count;
    final String? next;
    final String? previous;
    final List<FavoriteProductResult>? results;

    FavoriteProducts({
        this.count,
        this.next,
        this.previous,
        this.results,
    });

    FavoriteProducts copyWith({
        int? count,
        String? next,
        dynamic previous,
        List<FavoriteProductResult>? results,
    }) => 
        FavoriteProducts(
            count: count ?? this.count,
            next: next ?? this.next,
            previous: previous ?? this.previous,
            results: results ?? this.results,
        );

    factory FavoriteProducts.fromMap(Map<String, dynamic> json) => FavoriteProducts(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null ? [] : List<FavoriteProductResult>.from(json["results"]!.map((x) => FavoriteProductResult.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toMap())),
    };
}

class FavoriteProductResult {
    final int? id;
    final ProductModel? product;
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
        ProductModel? product,
        DateTime? createdAt,
        int? owner,
    }) => 
        FavoriteProductResult(
            id: id ?? this.id,
            product: product ?? this.product,
            createdAt: createdAt ?? this.createdAt,
            owner: owner ?? this.owner,
        );

    factory FavoriteProductResult.fromMap(Map<String, dynamic> json) => FavoriteProductResult(
        id: json["id"],
        product: json["product"] == null ? null : ProductModel.fromMap(json["product"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        owner: json["owner"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "product": product?.toMap(),
        "created_at": createdAt?.toIso8601String(),
        "owner": owner,
    };
}
