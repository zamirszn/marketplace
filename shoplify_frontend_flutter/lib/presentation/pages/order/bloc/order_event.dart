part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

final class PlaceOrder extends OrderEvent {
  final CartParamsModel params;

  PlaceOrder({required this.params});
}

final class GetMyOrder extends OrderEvent {
  final GetMyOrderParams params;

  GetMyOrder({required this.params});

}

final class SetMyOrderFilter extends OrderEvent {
  final MyOrderFilter myOrderFilter;

  SetMyOrderFilter({required this.myOrderFilter});
}
