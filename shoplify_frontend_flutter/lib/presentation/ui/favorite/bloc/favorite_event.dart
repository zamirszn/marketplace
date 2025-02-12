part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteEvent {}

final class GetFavoriteProductEvent extends FavoriteEvent {
  final FavoriteProductParamsModel params;

  GetFavoriteProductEvent({required this.params});
}

final class RefreshFavoriteProductEvent extends FavoriteEvent {
  final FavoriteProductParamsModel params;

  RefreshFavoriteProductEvent({required this.params});
}




