part of 'star_rating_bloc.dart';

@immutable
sealed class StarRatingEvent extends Equatable {
  const StarRatingEvent();

  @override
  List<Object> get props => [];
}

class RatingChangedEvent extends StarRatingEvent {
  final double rating;

  const RatingChangedEvent(this.rating);

  @override
  List<Object> get props => [rating];
}
