part of 'remove_from_cart_bloc.dart';

@immutable
sealed class RemoveFromCartEvent {}

final class RemoveProductFromCartById extends RemoveFromCartEvent {
  final RemoveFromCartModelParams removeFromCartModelParams;

  RemoveProductFromCartById({required this.removeFromCartModelParams});
}




