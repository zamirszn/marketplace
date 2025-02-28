import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/cart_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState(cartItems: {})) {
    on<DecreaseSingleCartItemCountEvent>(_onDecreaseSingleCartItemUnit);
    on<IncreaseSingleCartItemCountEvent>(_onIncreaseSingleCartItemUnit);
  }

  _onDecreaseSingleCartItemUnit(
      DecreaseSingleCartItemCountEvent event, Emitter<CartState> emit) async {}

  _onIncreaseSingleCartItemUnit(
      IncreaseSingleCartItemCountEvent event, Emitter<CartState> emit) async {
    // final updatedItem =
    //     state.singleItem?.copyWith(quantity: state.singleItem!.quantity! + 1);
    // emit(state.copyWith(singleItem: updatedItem));
  }
}
