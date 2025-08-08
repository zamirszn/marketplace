part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

final class PlaceOrder extends OrderEvent {
  final CartParamsModel params;

  PlaceOrder({required this.params});
}

// was working on add create order feature

final List<int> s = [1, 5,3,4,2,10,7,8,9];








