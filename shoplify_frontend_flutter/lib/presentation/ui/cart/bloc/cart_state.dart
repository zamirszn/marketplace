part of 'cart_bloc.dart';

class CartState extends Equatable {
  final Map<String, CartItem>
      cartItems; // Map of productId to CartItem for the list

  const CartState({
    required this.cartItems,
  });

  CartState copyWith({
    ProductModelEntity? singleItem,
    Map<String, CartItem>? cartItems,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
    );
  }

  @override
  List<Object?> get props => [ cartItems];
}
