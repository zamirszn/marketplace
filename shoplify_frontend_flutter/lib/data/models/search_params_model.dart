// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SearchParamsModel {
  final String searchText;
  final int? page;
  final bool? discount;
  final bool? flashSale;
  final String? categoryId;
  final String? priceGreaterThan;
  final String? priceLessThan;
  SearchParamsModel({
    required this.searchText,
    this.page,
    this.discount,
    this.flashSale,
    this.categoryId,
    this.priceGreaterThan,
    this.priceLessThan,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'search': searchText,
      'page': page,
      'discount': discount,
      'flash_sales': flashSale,
      'category_id': categoryId,
      'old_price__gt': priceGreaterThan,
      'old_price__lt': priceLessThan,
    };
  }

  factory SearchParamsModel.fromMap(Map<String, dynamic> map) {
    return SearchParamsModel(
      searchText: map['search'] as String,
      page: map['page'] != null ? map['page'] as int : null,
      discount: map['discount'] != null ? map['discount'] as bool : null,
      flashSale: map['flash_sales'] != null ? map['flash_sales'] as bool : null,
      categoryId:
          map['category_id'] != null ? map['category_id'] as String : null,
      priceGreaterThan:
          map['old_price__gt'] != null ? map['old_price__gt'] as String : null,
      priceLessThan:
          map['old_price__lt'] != null ? map['old_price__lt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchParamsModel.fromJson(String source) =>
      SearchParamsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
