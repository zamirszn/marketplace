// ignore_for_file: public_member_api_docs, sort_constructors_first

class ProductQueryParamsModel {
  final int? page;
  ProductQueryParamsModel({
    required this.page,
  });

  ProductQueryParamsModel copyWith({
    int? page,
  }) {
    return ProductQueryParamsModel(
      page: page ?? this.page,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
    };
  }

  factory ProductQueryParamsModel.fromMap(Map<String, dynamic> map) {
    return ProductQueryParamsModel(
      page: map['page'] as int,
    );
  }
}
