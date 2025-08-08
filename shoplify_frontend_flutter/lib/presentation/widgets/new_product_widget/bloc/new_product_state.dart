part of 'new_product_bloc.dart';

@immutable
sealed class NewProductState {}

final class NewProductInitial extends NewProductState {}

// New Product States
final class NewProductLoading extends NewProductState {}

final class NewProductEmpty extends NewProductState {}

final class NewProductSuccess extends NewProductState {
  final List<Product> newProducts;

  NewProductSuccess({required this.newProducts});
}

final class NewProductFailure extends NewProductState {
  final String message;

  NewProductFailure({required this.message});

}
