import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/add_to_cart_params_model.dart';
import 'package:shoplify/data/models/cart_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'add_to_cart_bottomsheet_event.dart';
part 'add_to_cart_bottomsheet_state.dart';

class AddToCartBottomsheetBloc
    extends Bloc<AddToCartBottomsheetEvent, AddToCartBottomsheetState> {
  AddToCartBottomsheetBloc() : super(const AddToCartBottomsheetState()) {
    on<SetCartItem>(_onSetCartItem);
    on<IncreaseCartItemCountEvent>(_onIncreaseCartItemCount);
    on<DecreaseCartItemCountEvent>(_onDecreaseCartItemCount);
    on<AddItemToCartEvent>(_onAddItemToCartCount);
    on<ResetCartItemCountEvent>(_onResetItemCartCount);
  }

  void _onAddItemToCartCount(
      AddItemToCartEvent event, Emitter<AddToCartBottomsheetState> emit) async {
    emit(state.copyWith(status: AddToCartStatus.loading));
    final Either response = await sl<AddToCartUseCase>().call(
        params: AddToCartParamsModel(
            productId: state.selectedProductId!, quantity: state.itemCount));

    response.fold((error) {
      emit(
          state.copyWith(status: AddToCartStatus.failure, errorMessage: error));
    }, (data) {
      final CartItem cartItem = CartItem.fromMap(data);
      emit(state.copyWith(
          status: AddToCartStatus.success, cartItemToAdd: cartItem));
    });
  }

  void _onResetItemCartCount(ResetCartItemCountEvent event,
      Emitter<AddToCartBottomsheetState> emit) async {
    emit(state.copyWith(
        selectedProductId: null,
        itemCount: 1,
        status: AddToCartStatus.initial,
        cartItemToAdd: null,
        errorMessage: null));
  }

  void _onSetCartItem(
      SetCartItem event, Emitter<AddToCartBottomsheetState> emit) {
    emit(state.copyWith(
        status: AddToCartStatus.initial, selectedProductId: event.product.id));
  }

  void _onIncreaseCartItemCount(IncreaseCartItemCountEvent event,
      Emitter<AddToCartBottomsheetState> emit) {
    final int currentItemCount = state.itemCount;
    emit(state.copyWith(
        status: AddToCartStatus.initial, itemCount: currentItemCount + 1));
  }

  void _onDecreaseCartItemCount(DecreaseCartItemCountEvent event,
      Emitter<AddToCartBottomsheetState> emit) {
    if (state.itemCount == 1) {
      return;
    }
    final int currentItemCount = state.itemCount;

    emit(state.copyWith(
        status: AddToCartStatus.initial, itemCount: currentItemCount - 1));
  }
}
