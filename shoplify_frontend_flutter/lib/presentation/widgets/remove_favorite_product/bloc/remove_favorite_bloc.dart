import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'remove_favorite_event.dart';
part 'remove_favorite_state.dart';

class RemoveFavoriteBloc
    extends Bloc<RemoveFavoriteEvent, RemoveFavoriteState> {
  RemoveFavoriteBloc() : super(RemoveFavoriteInitial()) {
    on<RemoveFromFavoriteEvent>(_removeFromFavorite);
  }

  void _removeFromFavorite(
      RemoveFromFavoriteEvent event, Emitter<RemoveFavoriteState> emit) {
    emit(RemoveFromFavoriteLoading());
    
  }
}
