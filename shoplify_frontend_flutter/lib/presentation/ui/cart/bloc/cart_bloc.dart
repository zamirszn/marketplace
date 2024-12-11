import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/cart_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState(singleItem: null, cartItems: {})) {
    on<DecreaseCartItemCountEvent>(_onDecreaseCartItemUnit);
    on<IncreaseSingleCartItemCountEvent>(_onIncreaseSingleCartItemUnit);
    on<SetSingleItemEvent>(_onSetSingleCartItem);
  }

  _onSetSingleCartItem(SetSingleItemEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(singleItem: event.item));
  }

  _onDecreaseCartItemUnit(
      DecreaseCartItemCountEvent event, Emitter<CartState> emit) async {}

  _onIncreaseSingleCartItemUnit(
      IncreaseSingleCartItemCountEvent event, Emitter<CartState> emit) async {
    if (state.singleItem != null) {
      final updatedItem =
          state.singleItem?.copyWith(quantity: state.singleItem!.quantity! + 1);
      emit(state.copyWith(singleItem: updatedItem));
    }
  }
}
