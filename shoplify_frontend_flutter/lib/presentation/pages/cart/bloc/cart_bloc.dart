import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/cart_model.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<DecreaseSingleCartItemCountEvent>(_onDecreaseSingleCartItemUnit);
    on<IncreaseSingleCartItemCountEvent>(_onIncreaseSingleCartItemUnit);
    on<GetCartEvent>(_onGetCart);
    on<RemoveProductFromCartPageEvent>(_onRemoveProductFromCartPage);
    on<AddProductToCartPageEvent>(_onAddProductToCartPage);
  }

  void _onAddProductToCartPage(
      AddProductToCartPageEvent event, Emitter<CartState> emit) async {
    // check if item is in the cart List
    List<CartItem> updateCartList = List.from(state.cart!.items!);

    for (var cartItem in state.cart!.items!) {
      if (cartItem.product?.id == event.cartItem.product?.id) {
        print("object exists");

        // if product exist in cart List get the index of the item
        int index = state.cart!.items!.indexWhere(
            (item) => item.product?.id == event.cartItem.product?.id);

        // update the quantity of the cart item using its index
        state.cart!.items![index].quantity = event.cartItem.quantity;

        num cartTotal = state.cart!.cartTotal!;
        num productSubTotal =
            event.quantityToAdd * event.cartItem.product!.price!;
        // update the cart total
        num cartNewTotal = cartTotal + productSubTotal;
        emit(state.copyWith(
            cart: CartModel(
                cartTotal: cartNewTotal,
                id: state.cart?.id,
                items: updateCartList)));

        return;
      }
    }

    updateCartList.add(event.cartItem);
    num newCartItemTotal =
        (event.cartItem.product!.price! * event.quantityToAdd);
    num newCartTotal = state.cart!.cartTotal! + newCartItemTotal;
    emit(state.copyWith(
        cart: CartModel(
            cartTotal: newCartTotal,
            id: state.cart?.id,
            items: updateCartList)));
  }

  void _onRemoveProductFromCartPage(
      RemoveProductFromCartPageEvent event, Emitter<CartState> emit) {
    CartItem cartItemtoRemove = state.cart!.items!
        .where((cartItem) => cartItem.product?.id == event.cartItemId)
        .first;

    num cartItemtoRemoveTotalPrice =
        (cartItemtoRemove.product!.price! * cartItemtoRemove.quantity!);

    List<CartItem> updatedCartList = List.from(state.cart!.items!)
      ..removeWhere((cartItem) => cartItem.product?.id == event.cartItemId);

    final newCartTotal = state.cart!.cartTotal! - cartItemtoRemoveTotalPrice;

    CartModel cart = CartModel(
        id: state.cart?.id, cartTotal: newCartTotal, items: updatedCartList);

    emit(state.copyWith(cart: cart));
  }

  void _onGetCart(GetCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    Either response = await sl<GetorCreateCartUseCase>().call();
    response.fold((error) {
      emit(state.copyWith(status: CartStatus.failure, errorMessage: error));
    }, (data) {
      final CartModel cart = CartModel.fromMap(data);
      emit(
        state.copyWith(
          cart: cart,
          status: CartStatus.success,
        ),
      );
    });
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
