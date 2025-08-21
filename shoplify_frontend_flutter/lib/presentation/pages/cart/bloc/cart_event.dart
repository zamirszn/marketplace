part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}



final class GetCartEvent extends CartEvent {}

final class AddProductToCartPageEvent extends CartEvent {
  final CartItem cartItem;
  final int quantityToAdd;

  AddProductToCartPageEvent(
      {required this.cartItem, required this.quantityToAdd});
}

final class RemoveProductFromCartPageEvent extends CartEvent {
  final String cartItemId;

  RemoveProductFromCartPageEvent({required this.cartItemId});
}

final class IncreaseCartItemQuantityEvent extends CartEvent {
  final Product product;

  IncreaseCartItemQuantityEvent({required this.product});
}

final class DecreaseCartItemQuantityEvent extends CartEvent {
  final Product product;

  DecreaseCartItemQuantityEvent({required this.product});
}
