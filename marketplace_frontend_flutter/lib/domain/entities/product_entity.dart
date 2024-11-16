import 'package:marketplace/data/models/product_category_model.dart';
import 'package:marketplace/data/models/product_model.dart';

class ProductModelEntity {
  final String? id;
  final String? name;
  final String? description;
  final ProductCategoryModel? category;
  final bool? discount;
  final double? oldPrice;
  final double? price;
  final String? slug;
  final int? inventory;
  final num? averageRating;
  final List<ProductImage> images;

  ProductModelEntity({
    this.id,
    this.name,
    this.description,
    this.category,
    this.discount,
    this.oldPrice,
    this.price,
    this.slug,
    this.inventory,
    this.averageRating,
    required this.images,
  });
}
