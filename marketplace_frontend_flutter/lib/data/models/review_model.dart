import 'dart:convert';

import 'package:marketplace/domain/entities/review_entity.dart';

class ReviewModel {
  final int? id;
  final DateTime? dateCreated;
  final String? description;
  final Owner? owner;
  final double? rating;

  ReviewModel({
    this.id,
    this.dateCreated,
    this.description,
    this.owner,
    this.rating,
  });

  ReviewModel copyWith({
    int? id,
    DateTime? dateCreated,
    String? description,
    Owner? owner,
    double? rating,
  }) =>
      ReviewModel(
        id: id ?? this.id,
        dateCreated: dateCreated ?? this.dateCreated,
        description: description ?? this.description,
        owner: owner ?? this.owner,
        rating: rating ?? this.rating,
      );

  factory ReviewModel.fromMap(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        description: json["description"],
        owner: json["owner"] == null ? null : Owner.fromMap(json["owner"]),
        rating: double.tryParse(json["rating"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "date_created": dateCreated?.toIso8601String(),
        "description": description,
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
        description: description,
        id: id,
        owner: owner,
        rating: rating);
  }
}
