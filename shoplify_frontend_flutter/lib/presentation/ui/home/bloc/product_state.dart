// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_bloc.dart';

@immutable
sealed class ProductState extends Equatable {
  @override
  List<Object?> get props => []; // Default empty props for base class
}

final class ProductInitial extends ProductState {}

// Product Category States
final class ProductCategoryLoading extends ProductState {}

final class ProductCategoryFailure extends ProductState {}

final class ProductCategorySuccess extends ProductState {
  final List<ProductCategoryEntity> productCategories;

  ProductCategorySuccess({required this.productCategories});

  @override
  List<Object?> get props => [productCategories];
}

final class ProductCategoryUpdate extends ProductState {
  final String selectedCategory;

  ProductCategoryUpdate({required this.selectedCategory});

  @override
  List<Object?> get props => [selectedCategory];
}

// New Product States
final class NewProductLoading extends ProductState {}

final class NewProductEmpty extends ProductState {}

final class NewProductSuccess extends ProductState {
  final List<ProductModelEntity> newProducts;

  NewProductSuccess({required this.newProducts});

  @override
  List<Object?> get props => [newProducts];
}

final class NewProductFailure extends ProductState {
  final String message;

  NewProductFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Popular Product States
final class PopularProductLoading extends ProductState {}

final class PopularProductFailure extends ProductState {
  final String message;

  PopularProductFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

final class PopularProductEmpty extends ProductState {}

final class PopularProductSuccess extends ProductState {
  final List<ProductModelEntity> popularProducts;

  PopularProductSuccess({required this.popularProducts});

  @override
  List<Object?> get props => [popularProducts];
}

// All Products

final class AllProductLoading extends ProductState {}

final class AllProductFailure extends ProductState {
  final String message;

  AllProductFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

final class AllProductEmpty extends ProductState {}

final class AllProductSuccess extends ProductState {
  final List<ProductModelEntity> products;
  final bool hasReachedMax;

  AllProductSuccess({
    required this.products,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [products, hasReachedMax];

  AllProductSuccess copyWith({
    List<ProductModelEntity>? products,
    bool? hasReachedMax,
  }) {
    return AllProductSuccess(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

// add to cart

final class AddToCartLoading extends ProductState {}

final class AddToCartFailure extends ProductState {}

final class AddToCartSuccess extends ProductState {}
// create cart

final class CreateorGetCartFailure extends ProductState {
  final String message;

  CreateorGetCartFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

final class CreateorGetCartLoading extends ProductState {}

final class CreateorGetCartSuccess extends ProductState {
  final CartModel cart;

  CreateorGetCartSuccess({required this.cart});

  @override
  List<Object?> get props => [cart];
}

final class CartItemState extends ProductState {
  final int quantity;

  CartItemState({required this.quantity});

  @override
  List<Object?> get props => [quantity];

  CartItemState copyWith({int? itemCount}) {
    return CartItemState(quantity: itemCount ?? quantity);
  }
}

// add to favorite

class AddToFavoriteLoading extends ProductState {
  
}

class AddToFavoriteFailure extends ProductState {
  final String message;

  AddToFavoriteFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ToggleFavoriteSuccess extends ProductState {
  final String productId;
  final bool isFavorited;
  final String? message;




  ToggleFavoriteSuccess({
    required this.productId,
    required this.isFavorited,
    required this.message
  });

  @override
  List<Object?> get props => [productId, isFavorited, message];
}
