// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shoplify/domain/entities/review_entity.dart';

class ReviewModel {
  final int? id;
  final DateTime? dateCreated;
  final String? review;
  final Owner? owner;
  final double? rating;

  ReviewModel({
    this.id,
    this.dateCreated,
    this.review,
    this.owner,
    this.rating,
  });

  ReviewModel copyWith({
    int? id,
    DateTime? dateCreated,
    String? review,
    Owner? owner,
    double? rating,
  }) =>
      ReviewModel(
        id: id ?? this.id,
        dateCreated: dateCreated ?? this.dateCreated,
        review: review ?? this.review,
        owner: owner ?? this.owner,
        rating: rating ?? this.rating,
      );

  factory ReviewModel.fromMap(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        review: json["review"],
        owner: json["owner"] == null ? null : Owner.fromMap(json["owner"]),
        rating: double.tryParse(json["rating"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "date_created": dateCreated?.toIso8601String(),
        "review": review,
        "owner": owner?.toMap(),
        "rating": rating,
      };
}

class Owner {
  final int? id;
  final String? fullName;

  Owner({
    this.id,
    this.fullName,
  });

  Owner copyWith({
    int? id,
    String? fullName,
  }) =>
      Owner(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
      );

  factory Owner.fromMap(Map<String, dynamic> json) => Owner(
        id: json["id"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "full_name": fullName,
      };
}

extension ReviewModelXModel on ReviewModel {
  ReviewModelEntity toEntity() {
    return ReviewModelEntity(
        dateCreated: dateCreated,
        review: review,
        id: id,
        owner: owner,
        rating: rating);
  }
}

class SubmitReviewModel {
  final String productId;
  final String review;
  final num? rating;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': productId,
      'review': review,
      'rating': rating,
    };
  }

  factory SubmitReviewModel.fromMap(Map<String, dynamic> map) {
    return SubmitReviewModel(
      productId: map['product'] as String,
      review: map['review'] as String,
      rating: map['rating'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubmitReviewModel.fromJson(String source) =>
      SubmitReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  SubmitReviewModel(
      {required this.productId, required this.review, required this.rating});
}
