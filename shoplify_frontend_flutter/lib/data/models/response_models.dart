// To parse this JSON data, do
//
//     final allProductresponseModel = allProductresponseModelFromMap(jsonString);

import 'dart:convert';

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
