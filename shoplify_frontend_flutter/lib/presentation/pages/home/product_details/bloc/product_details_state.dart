// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_details_bloc.dart';

enum ProductDetailsStatus { initial, loading, failure, success }

class ProductDetailsState extends Equatable {
  final Product? selectedProduct;
  final String? errorMessage;
  final ProductDetailsStatus status;

  const ProductDetailsState({
    this.selectedProduct,
    this.errorMessage,
    this.status = ProductDetailsStatus.initial,
  });

  @override
  List<Object?> get props => [selectedProduct, errorMessage, status];

  ProductDetailsState copyWith({
    Product? selectedProduct,
    String? errorMessage,
    ProductDetailsStatus? status,
  }) {
    return ProductDetailsState(
      selectedProduct: selectedProduct ?? this.selectedProduct,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
