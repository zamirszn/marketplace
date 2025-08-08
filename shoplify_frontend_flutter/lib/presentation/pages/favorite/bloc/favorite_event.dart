part of 'favorite_bloc.dart';

@immutable

///event for the `FavoritePage`
sealed class FavoriteEvent {}

final class GetFavoriteProductEvent extends FavoriteEvent {
  final FavoriteProductParamsModel params;

  GetFavoriteProductEvent({required this.params});
}

final class RefreshFavoriteProductEvent extends FavoriteEvent {
  final FavoriteProductParamsModel params;

  RefreshFavoriteProductEvent({required this.params});
}
/// event removes products from the `FavoritePage` list using
/// thier id
class RemoveFromFavoritePageEvent extends FavoriteEvent {
  final String productId;

  RemoveFromFavoritePageEvent({required this.productId});
}

/// event adds product object to the `FavoritePage` list
final class AddToFavoritePageEvent extends FavoriteEvent {
  final Product product;

  AddToFavoritePageEvent({required this.product});
}
