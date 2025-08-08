part of 'product_details_bloc.dart';

@immutable
sealed class ProductDetailsEvent {}

final class RefreshProductDetailsEvent extends ProductDetailsEvent {
  final String productId;

  RefreshProductDetailsEvent({required this.productId});
}

final class SetProductDetailsEvent extends ProductDetailsEvent {
  final Product product;

  SetProductDetailsEvent({required this.product});
}
