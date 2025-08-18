part of 'all_products_bloc.dart';

@immutable
sealed class AllProductsEvent {}

class GetAllProductsEvent extends AllProductsEvent {
  final ProductQueryParamsModel params;

  GetAllProductsEvent({required this.params});
}

class ResetAllProductListEvent extends AllProductsEvent {}

class SetViewProductImageUrl extends AllProductsEvent {
  final String imageUrl;

  SetViewProductImageUrl({required this.imageUrl});
}
