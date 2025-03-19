// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SearchParamsModel {
  final String searchText;
  final int? page;

  SearchParamsModel({required this.searchText, required this.page});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'search': searchText,
      'page': page,
    };
  }

  factory SearchParamsModel.fromMap(Map<String, dynamic> map) {
    return SearchParamsModel(
      searchText: map['search'] as String,
      page: map['page'] != null ? map['page'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchParamsModel.fromJson(String source) =>
      SearchParamsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
