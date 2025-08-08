// ignore_for_file: public_member_api_docs, sort_constructors_first


class ProductCategory {
  final String name;
  final String categoryId;

  ProductCategory({required this.name, required this.categoryId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'category_id': categoryId,
    };
  }

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      name: map['name'] as String,
      categoryId: map['category_id'] as String,
    );
  }
}
