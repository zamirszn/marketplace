// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final cartModel = cartModelFromMap(jsonString);

import 'dart:convert';


import 'package:shoplify/data/models/product_model.dart';

CartModel cartModelFromMap(String str) => CartModel.fromMap(json.decode(str));

String cartModelToMap(CartModel data) => json.encode(data.toMap());

class CartModel {
  final String? id;
  final List<CartItem>? items;
  final num? cartTotal;

  CartModel({
    this.id,
    this.items,
    this.cartTotal,
  });

  CartModel copyWith({
    String? id,
    List<CartItem>? items,
    double? cartTotal,
  }) =>
      CartModel(
        id: id ?? this.id,
        items: items ?? this.items,
        cartTotal: cartTotal ?? this.cartTotal,
      );

  factory CartModel.fromMap(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        items: json["items"] == null
            ? []
            : List<CartItem>.from(
                json["items"]!.map((x) => CartItem.fromMap(x))),
        cartTotal: json["cart_total"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toMap())),
        "cart_total": cartTotal,
      };
}

class CartItem {
  final int? id;
  final String? cart;
  final ProductModel? product;
  int? quantity;
  final double? subTotal;

  CartItem({
    this.id,
    this.cart,
    this.product,
    this.quantity,
    this.subTotal,
  });

  CartItem copyWith({
    int? id,
    String? cart,
    ProductModel? product,
    int? quantity,
    double? subTotal,
  }) =>
      CartItem(
        id: id ?? this.id,
        cart: cart ?? this.cart,
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
        subTotal: subTotal ?? this.subTotal,
      );

  factory CartItem.fromMap(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        cart: json["cart"],
        product: json["product"] == null
            ? null
            : ProductModel.fromMap(json["product"]),
        quantity: json["quantity"],
        subTotal: json["sub_total"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "cart": cart,
        "product": product?.toMap(),
        "quantity": quantity,
        "sub_total": subTotal,
      };
}

class RemoveFromCartModelParams {
  final int cartItemId;
  final String cartId;
  RemoveFromCartModelParams({
    required this.cartItemId,
    required this.cartId,
  });

  RemoveFromCartModelParams copyWith({
    int? cartItemId,
    String? cartId,
  }) {
    return RemoveFromCartModelParams(
      cartItemId: cartItemId ?? this.cartItemId,
      cartId: cartId ?? this.cartId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartItemId': cartItemId,
      'cartId': cartId,
    };
  }

  factory RemoveFromCartModelParams.fromMap(Map<String, dynamic> map) {
    return RemoveFromCartModelParams(
      cartItemId: map['cartItemId'] as int,
      cartId: map['cartId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoveFromCartModelParams.fromJson(String source) =>
      RemoveFromCartModelParams.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RemoveFromCartModelParams(cartItemId: $cartItemId, cartId: $cartId)';

  @override
  bool operator ==(covariant RemoveFromCartModelParams other) {
    if (identical(this, other)) return true;

    return other.cartItemId == cartItemId && other.cartId == cartId;
  }

  @override
  int get hashCode => cartItemId.hashCode ^ cartId.hashCode;
}
