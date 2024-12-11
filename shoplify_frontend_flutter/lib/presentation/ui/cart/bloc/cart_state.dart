part of 'cart_bloc.dart';

class CartState extends Equatable {
  final CartItem? singleItem; // Single item for single-page use
  final Map<String, CartItem>
      cartItems; // Map of productId to CartItem for the list

  const CartState({
    this.singleItem,
    required this.cartItems,
  });

  CartState copyWith({
    CartItem? singleItem,
    Map<String, CartItem>? cartItems,
  }) {
    return CartState(
      singleItem: singleItem ?? this.singleItem,
      cartItems: cartItems ?? this.cartItems,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [singleItem, cartItems];
}
