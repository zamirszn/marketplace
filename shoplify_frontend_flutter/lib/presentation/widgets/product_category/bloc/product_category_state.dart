part of 'product_category_bloc.dart';

@immutable
sealed class ProductCategoryState {}

final class ProductCategoryInitial extends ProductCategoryState {}

// Product Category States
final class ProductCategoryLoading extends ProductCategoryState {}

final class ProductCategoryFailure extends ProductCategoryState {}

final class ProductCategorySuccess extends ProductCategoryState {
  final List<ProductCategoryEntity> productCategories;

  ProductCategorySuccess({required this.productCategories});
}
