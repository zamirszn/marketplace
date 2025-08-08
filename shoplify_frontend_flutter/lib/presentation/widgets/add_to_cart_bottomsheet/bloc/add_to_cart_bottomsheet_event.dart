part of 'add_to_cart_bottomsheet_bloc.dart';

@immutable
sealed class AddToCartBottomsheetEvent {}

final class IncreaseCartItemCountEvent extends AddToCartBottomsheetEvent {}

final class DecreaseCartItemCountEvent extends AddToCartBottomsheetEvent {}

final class ResetCartItemCountEvent extends AddToCartBottomsheetEvent {}

final class AddItemToCartEvent extends AddToCartBottomsheetEvent {}

final class SetCartItem extends AddToCartBottomsheetEvent {
  final Product product;
  SetCartItem({required this.product});
}
