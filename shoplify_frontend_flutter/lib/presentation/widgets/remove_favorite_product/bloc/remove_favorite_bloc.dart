import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'remove_favorite_event.dart';
part 'remove_favorite_state.dart';

class RemoveFavoriteBloc
    extends Bloc<RemoveFavoriteEvent, RemoveFavoriteState> {
  RemoveFavoriteBloc() : super(RemoveFavoriteInitial()) {
    on<RemoveFromFavoriteByIdEvent>(_removeFromFavorite);
  }

  void _removeFromFavorite(RemoveFromFavoriteByIdEvent event,
      Emitter<RemoveFavoriteState> emit) async {
    emit(RemoveFromFavoriteLoading());

    final Either response =
        await sl<RemovefromFavoriteUseCase>().call(params: event.productId);

    response.fold((error) {
      emit(RemoveFromFavoriteFailure(message: error.toString()));
    }, (data) {
      emit(RemoveFromFavoriteSuccess());
    });
  }
}
