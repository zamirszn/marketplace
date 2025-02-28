part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class IncreaseSingleCartItemCountEvent extends CartEvent {}

class DecreaseSingleCartItemCountEvent extends CartEvent {}



// class IncreaseCartItemCountEvent extends CartEvent {
//   final String productId;

//   IncreaseCartItemCountEvent(this.productId);
// }

// class DecreaseCartItemCountEvent extends CartEvent {
//   final String productId;

//   DecreaseCartItemCountEvent(this.productId);
// }
