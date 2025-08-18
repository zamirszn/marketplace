// To parse this JSON data, do
//
//     final allProductresponseModel = allProductresponseModelFromMap(jsonString);

import 'dart:convert';

import 'package:shoplify/data/models/favorite_product_model.dart';
import 'package:shoplify/data/models/product_model.dart';

AllProductresponseModel allProductresponseModelFromMap(String str) =>
    AllProductresponseModel.fromMap(json.decode(str));

String allProductresponseModelToMap(AllProductresponseModel data) =>
    json.encode(data.toMap());

class AllProductresponseModel {
  final int? count;
  final String? next;
  final String? previous;
  final List<Product>? results;

  AllProductresponseModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory AllProductresponseModel.fromMap(Map<String, dynamic> json) =>
      AllProductresponseModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<Product>.from(
                json["results"]!.map((x) => Product.fromMap(x))),
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

GetProfileResponseModel getProfileResponseModelFromMap(String str) =>
    GetProfileResponseModel.fromMap(json.decode(str));

String getProfileResponseModelToMap(GetProfileResponseModel data) =>
    json.encode(data.toMap());

class GetProfileResponseModel {
  final int? id;
  final String? phone;
  final dynamic profilePicture;
  final String? shippingAddress;
  final bool? notificationsEnabled;
  final String? fullName;
  final String? email;

  GetProfileResponseModel({
    this.id,
    this.phone,
    this.profilePicture,
    this.shippingAddress,
    this.notificationsEnabled,
    this.fullName,
    this.email,
  });

  factory GetProfileResponseModel.fromMap(Map<String, dynamic> json) =>
      GetProfileResponseModel(
        id: json["id"],
        phone: json["phone"],
        email: json["email"],
        profilePicture: json["profilePicture"],
        shippingAddress: json["shipping_address"],
        notificationsEnabled: json["notifications_enabled"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "phone": phone,
        "email": email,
        "profilePicture": profilePicture,
        "shipping_address": shippingAddress,
        "notifications_enabled": notificationsEnabled,
        "full_name": fullName,
      };
}

MyOrderResponseModel myOrderResponseModelFromMap(String str) =>
    MyOrderResponseModel.fromMap(json.decode(str));

String myOrderResponseModelToMap(MyOrderResponseModel data) =>
    json.encode(data.toMap());

class MyOrderResponseModel {
  final int? count;
  final dynamic next;
  final dynamic previous;
  final List<MyOrderData>? results;

  MyOrderResponseModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory MyOrderResponseModel.fromMap(Map<String, dynamic> json) =>
      MyOrderResponseModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<MyOrderData>.from(
                json["results"]!.map((x) => MyOrderData.fromMap(x))),
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

class MyOrderData {
  final List<Item>? items;
  final int? id;
  final DateTime? placedAt;
  final String? orderStatus;
  final int? owner;

  MyOrderData({
    this.items,
    this.id,
    this.placedAt,
    this.orderStatus,
    this.owner,
  });

  factory MyOrderData.fromMap(Map<String, dynamic> json) => MyOrderData(
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromMap(x))),
        id: json["id"],
        placedAt: json["placed_at"] == null
            ? null
            : DateTime.parse(json["placed_at"]),
        orderStatus: json["order_status"],
        owner: json["owner"],
      );

  Map<String, dynamic> toMap() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toMap())),
        "id": id,
        "placed_at": placedAt?.toIso8601String(),
        "order_status": orderStatus,
        "owner": owner,
      };
}

class Item {
  final int? id;
  final Product? product;
  final int? quantity;

  Item({
    this.id,
    this.product,
    this.quantity,
  });

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["id"],
        product:
            json["product"] == null ? null : Product.fromMap(json["product"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "product": product?.toMap(),
        "quantity": quantity,
      };
}

// To parse this JSON data, do
//
//     final addFavoriteResponseModel = addFavoriteResponseModelFromMap(jsonString);

AddFavoriteResponseModel addFavoriteResponseModelFromMap(String str) =>
    AddFavoriteResponseModel.fromMap(json.decode(str));

String addFavoriteResponseModelToMap(AddFavoriteResponseModel data) =>
    json.encode(data.toMap());

class AddFavoriteResponseModel {
  final String? message;
  final FavoriteProductResult? favorite;

  AddFavoriteResponseModel({
    this.message,
    this.favorite,
  });

  factory AddFavoriteResponseModel.fromMap(Map<String, dynamic> json) =>
      AddFavoriteResponseModel(
        message: json["message"],
        favorite: json["favorite"] == null
            ? null
            : FavoriteProductResult.fromMap(json["favorite"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "favorite": favorite?.toMap(),
      };
}
