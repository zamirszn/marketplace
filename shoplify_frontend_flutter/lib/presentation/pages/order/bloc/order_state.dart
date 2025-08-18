// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

part of 'order_bloc.dart';

enum MyOrderFilter {
  PAYMENT_STATUS_PENDING,
  PAYMENT_STATUS_COMPLETE,
  PAYMENT_STATUS_FAILED,
  ORDER_DELIVERED,
  ORDER_CANCELLED,
}

enum MyOrderStatus { initial, success, failure }

class OrderState extends Equatable {
  final MyOrderFilter? selectedMyOrderFilter;
  final bool hasReachedMax;
  final String? errorMessage;
  final bool isFetching;
  final int page;
  final MyOrderStatus myOrderStatus;
  final List<MyOrderData> myOrderData;

  const OrderState(
      {this.selectedMyOrderFilter,
      this.hasReachedMax = false,
      this.errorMessage,
      this.myOrderData = const [],
      this.isFetching = false,
      this.page = 1,
      this.myOrderStatus = MyOrderStatus.initial});

  @override
  List<Object?> get props => [
        selectedMyOrderFilter,
        hasReachedMax,
        errorMessage,
        isFetching,
        myOrderStatus,
        myOrderData,
      ];

  OrderState copyWith({
    MyOrderFilter? selectedMyOrderFilter,
    bool? hasReachedMax,
    String? errorMessage,
    bool? isFetching,
    int? page,
    MyOrderStatus? myOrderStatus,
    List<MyOrderData>? myOrderData,
  }) {
    return OrderState(
      selectedMyOrderFilter:
          selectedMyOrderFilter ?? this.selectedMyOrderFilter,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      isFetching: isFetching ?? this.isFetching,
      page: page ?? this.page,
      myOrderStatus: myOrderStatus ?? this.myOrderStatus,
      myOrderData: myOrderData ?? this.myOrderData,
    );
  }
}
