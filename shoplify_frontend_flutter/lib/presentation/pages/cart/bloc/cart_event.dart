part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class IncreaseSingleCartItemCountEvent extends CartEvent {}

final class DecreaseSingleCartItemCountEvent extends CartEvent {}

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
