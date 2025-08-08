import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'remove_from_cart_event.dart';
part 'remove_from_cart_state.dart';

class RemoveFromCartBloc
    extends Bloc<RemoveFromCartEvent, RemoveFromCartState> {
  RemoveFromCartBloc() : super(RemoveFromCartInitial()) {
    on<RemoveProductFromCartById>(_onRemoveProductFromCart);
  }

  void _onRemoveProductFromCart(RemoveProductFromCartById event,
      Emitter<RemoveFromCartState> emit) async {
    emit(RemoveFromCartLoading());

    final Either response = await sl<RemoveFromCartUseCase>()
        .call(params: event.removeFromCartModelParams);
    response.fold((error) {
      emit(RemoveFromCartFailure(message: error));
    }, (data) {
      emit(RemoveFromCartSuccess());
    });
  }
}
