part of 'star_rating_bloc.dart';

class StarRatingState extends Equatable {
  final double rating;

  const StarRatingState(this.rating);

  @override
  List<Object> get props => [rating];
}
