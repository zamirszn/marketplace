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


final class AllProductFailure extends ProductState {
  final String message;

  AllProductFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

final class AllProductEmpty extends ProductState {}


// add to cart

final class CreateorGetCartFailure extends ProductState {
  final String errorMessage;

  CreateorGetCartFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
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
