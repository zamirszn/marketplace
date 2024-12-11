import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'star_rating_event.dart';
part 'star_rating_state.dart';

class StarRatingBloc extends Bloc<StarRatingEvent, StarRatingState> {
  StarRatingBloc() : super(const StarRatingState(0)) {
    on<RatingChangedEvent>((event, emit) {
      emit(StarRatingState(event.rating));
    });
  }
}
