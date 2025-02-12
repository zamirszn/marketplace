part of 'remove_favorite_bloc.dart';

@immutable
sealed class RemoveFavoriteEvent {}

final class RemoveFromFavoriteEvent extends RemoveFavoriteEvent {
  final String productId;

  RemoveFromFavoriteEvent({required this.productId});
}
