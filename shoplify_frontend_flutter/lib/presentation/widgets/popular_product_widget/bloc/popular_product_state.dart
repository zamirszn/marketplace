part of 'popular_product_bloc.dart';

@immutable
sealed class PopularProductState {}

final class PopularProductInitial extends PopularProductState {}

// Popular Product States
final class PopularProductLoading extends PopularProductState {}

final class PopularProductFailure extends PopularProductState {
  final String message;

  PopularProductFailure({required this.message});
}

final class PopularProductEmpty extends PopularProductState {}

final class PopularProductSuccess extends PopularProductState {
  final List<Product> popularProducts;

  PopularProductSuccess({required this.popularProducts});
}
