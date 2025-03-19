// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_bloc.dart';

@immutable
sealed class ProductState extends Equatable {
  @override
  List<Object?> get props => []; // Default empty props for base class
}

final class ProductInitial extends ProductState {}



// final class ProductCategoryUpdate extends ProductState {
//   final String selectedCategory;

//   ProductCategoryUpdate({required this.selectedCategory});

//   @override
//   List<Object?> get props => [selectedCategory];
// }



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

final class AddToCartSuccess extends ProductState {
  final CartItem? cartItemToAdd;

  AddToCartSuccess({required this.cartItemToAdd});
}
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

class AddToFavoriteLoading extends ProductState {}

class AddToFavoriteFailure extends ProductState {
  final String message;

  AddToFavoriteFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ToggleFavoriteAddSuccess extends ProductState {
  final ProductModelEntity? product;
  final bool isFavorited;
  final String? message;

  ToggleFavoriteAddSuccess(
      {this.product, required this.isFavorited, required this.message});

  @override
  List<Object?> get props => [product, isFavorited, message];
}

class ToggleFavoriteRemoveSuccess extends ProductState {
  final String? message;

  ToggleFavoriteRemoveSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
