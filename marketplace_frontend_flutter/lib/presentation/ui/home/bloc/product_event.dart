part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class GetProductCategoryEvent extends ProductEvent {}

class GetNewProductsEvent extends ProductEvent {}

class GetPopularProductsEvent extends ProductEvent {}

class GetAllProductsEvent extends ProductEvent {
  final ProductQueryParamsModel params;

  GetAllProductsEvent({required this.params});
}

class AddToCartEvent extends ProductEvent {
  final AddToCartParamsModel params;

  AddToCartEvent({required this.params});
}

class CreateorGetCartEvent extends ProductEvent {}
