// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shoplify/presentation/ui/favorite/bloc/favorite_bloc.dart';

class FavoriteProductParamsModel {
  final int? page;
  final FavoriteProductSort? ordering;

  FavoriteProductParamsModel({
    this.page,
    this.ordering,
    
  });

  FavoriteProductParamsModel copyWith({
    int? page,
    FavoriteProductSort? ordering,
  }) {
    return FavoriteProductParamsModel(
      page: page ?? this.page,
      
      ordering: ordering ?? this.ordering,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'ordering': ordering,
    };
  }

  factory FavoriteProductParamsModel.fromMap(Map<String, dynamic> map) {
    return FavoriteProductParamsModel(
      page: map['page'],
      ordering: map['ordering'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteProductParamsModel.fromJson(String source) =>
      FavoriteProductParamsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FavoriteProductParamsModel(page: $page, ordering: $ordering)';

  @override
  bool operator ==(covariant FavoriteProductParamsModel other) {
    if (identical(this, other)) return true;

    return other.page == page && other.ordering == ordering;
  }

  @override
  int get hashCode => page.hashCode ^ ordering.hashCode;
}
