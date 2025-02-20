part of 'remove_favorite_bloc.dart';

@immutable
sealed class RemoveFavoriteEvent {}

final class RemoveFromFavoriteByIdEvent extends RemoveFavoriteEvent {
  final String productId;

  RemoveFromFavoriteByIdEvent({required this.productId});
}
