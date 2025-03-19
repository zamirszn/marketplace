// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_bloc.dart';

enum CartStatus { initial, loading, failure, success }

class CartState extends Equatable {
  final CartModel? cart;
  final String? errorMessage;
  final CartStatus status;

  const CartState(
      {this.cart, this.errorMessage, this.status = CartStatus.initial});

  @override
  List<Object?> get props => [cart, errorMessage, status];

  CartState copyWith({
    CartModel? cart,
    String? errorMessage,
    CartStatus? status,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
