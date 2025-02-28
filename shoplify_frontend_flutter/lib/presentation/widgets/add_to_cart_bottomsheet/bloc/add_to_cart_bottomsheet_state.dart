// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_to_cart_bottomsheet_bloc.dart';

enum AddToCartStatus { initial, loading, success, failure }

class AddToCartBottomsheetState extends Equatable {
  final String? selectedProductId;
  final int itemCount;
  final AddToCartStatus status;
  final String? errorMessage;

  const AddToCartBottomsheetState(
      {this.selectedProductId,
      this.itemCount = 1,
      this.status = AddToCartStatus.initial, this.errorMessage});

  @override
  List<Object?> get props => [selectedProductId, itemCount, status, errorMessage];

  AddToCartBottomsheetState copyWith({
    String? selectedProductId,
    int? itemCount,
    AddToCartStatus? status,
       String? errorMessage,

  }) {
    return AddToCartBottomsheetState(
        selectedProductId: selectedProductId ?? this.selectedProductId,
        itemCount: itemCount ?? this.itemCount,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status);
  }
}
