// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_bloc.dart';

enum CartStatus { initial, loading, failure, success }

enum QuantityOperationStatus { idle, updating, success, failure }

class CartState extends Equatable {
  final CartModel? cart;
  final String? errorMessage;
  final CartStatus status;
  final QuantityOperationStatus quantityOperationStatus;
  final String? quantityOperationError;
  final int? operatingItemId;

  const CartState({
    this.cart,
    this.errorMessage,
    this.status = CartStatus.initial,
    this.quantityOperationStatus = QuantityOperationStatus.idle,
    this.quantityOperationError,
    this.operatingItemId,
  });

  @override
  List<Object?> get props => [
        cart,
        errorMessage,
        status,
        quantityOperationStatus,
        quantityOperationError,
        operatingItemId,
      ];

  CartState copyWith(
      {CartModel? cart,
      String? errorMessage,
      CartStatus? status,
      QuantityOperationStatus? quantityOperationStatus,
      String? quantityOperationError,
      int? operatingItemId}) {
    return CartState(
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      quantityOperationStatus:
          quantityOperationStatus ?? this.quantityOperationStatus,
      quantityOperationError:
          quantityOperationError ?? this.quantityOperationError,
      operatingItemId: operatingItemId ?? this.operatingItemId,
    );
  }

  
}
