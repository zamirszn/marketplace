part of 'remove_favorite_bloc.dart';

@immutable
sealed class RemoveFavoriteState {}

final class RemoveFavoriteInitial extends RemoveFavoriteState {}

final class RemoveFromFavoriteLoading extends RemoveFavoriteState {}

final class RemoveFromFavoriteSuccess extends RemoveFavoriteState {}

final class RemoveFromFavoriteFailure extends RemoveFavoriteState {}
