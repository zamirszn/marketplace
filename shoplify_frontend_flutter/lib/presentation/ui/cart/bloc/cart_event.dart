part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class IncreaseSingleCartItemCountEvent extends CartEvent {}

class SetSingleItemEvent extends CartEvent {
  final CartItem item;

  SetSingleItemEvent(this.item);
}

class IncreaseCartItemCountEvent extends CartEvent {
  final String productId;

  IncreaseCartItemCountEvent(this.productId);
}

class DecreaseCartItemCountEvent extends CartEvent {
  final String productId;

  DecreaseCartItemCountEvent(this.productId);
}
