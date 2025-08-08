part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}



class AddToCartEvent extends ProductEvent {
  final AddToCartParamsModel params;

  AddToCartEvent({required this.params});
}

class GetOrCreateCartEvent extends ProductEvent {}

class ToggleFavoriteEvent extends ProductEvent {
  final String productId;
  final bool isCurrentlyFavorited;

  ToggleFavoriteEvent({
    required this.productId,
    required this.isCurrentlyFavorited,
  });

 
}
