import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/cart_model.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<GetCartEvent>(_onGetCart);
    on<RemoveProductFromCartPageEvent>(_onRemoveProductFromCartPage);
    on<AddProductToCartPageEvent>(_onAddProductToCartPage);
    on<DecreaseCartItemQuantityEvent>((event, emit) async {
      // Check if cart exists
      if (state.cart?.items == null) {
        emit(state.copyWith(
          quantityOperationStatus: QuantityOperationStatus.failure,
          quantityOperationError: "Cart is empty",
        ));
        return;
      }

      // Find the cart item by product ID
      CartItem? cartItem;
      for (final item in state.cart?.items ?? []) {
        if (item.product?.id == event.product.id) {
          cartItem = item;
          break;
        }
      }

      if (cartItem == null) {
        emit(state.copyWith(
          quantityOperationStatus: QuantityOperationStatus.failure,
          quantityOperationError: "Item not found in cart",
        ));
        return;
      }

      // Check minimum quantity limit
      final int currentQuantity = cartItem.quantity ?? 0;

      if (currentQuantity <= 1) {
        emit(state.copyWith(
          quantityOperationStatus: QuantityOperationStatus.failure,
          quantityOperationError: "Quantity cannot be less than 1",
          operatingItemId: cartItem.id,
        ));
        return;
      }

      // Emit updating state
      emit(state.copyWith(
        quantityOperationStatus: QuantityOperationStatus.updating,
        operatingItemId: cartItem.id,
      ));

      // Make API call
      Either response = await sl<UpdateCartItemQuantityUseCase>().call(
        params: UpdateCartItemQuantityParams(
          cartId: state.cart?.id,
          cartItemId: cartItem.id,
          quantity: currentQuantity - 1,
        ),
      );

      response.fold((error) {
        emit(state.copyWith(
          quantityOperationStatus: QuantityOperationStatus.failure,
          quantityOperationError: error,
        ));
      }, (data) {
        final updatedItems = state.cart?.items?.map((item) {
          if (item.product?.id == event.product.id) {
            final newQuantity = (item.quantity ?? 0) - 1;
            final newSubTotal =
                (event.product.discountedPrice ?? 0) * newQuantity;
            return item.copyWith(
              quantity: newQuantity,
              subTotal: newSubTotal,
            );
          }
          return item;
        }).toList();

        // Calculate new cart total
        final newCartTotal = updatedItems?.fold<double>(
          0.0,
          (total, item) => total + (item.subTotal ?? 0),
        );

        final updatedCart = state.cart?.copyWith(
          items: updatedItems,
          cartTotal: newCartTotal,
        );

        emit(state.copyWith(
          cart: updatedCart,
          quantityOperationStatus: QuantityOperationStatus.success,
        ));
      });
    });

    on<IncreaseCartItemQuantityEvent>((event, emit) async {
      // Check if cart exists
      if (state.cart?.items == null) {
        emit(state.copyWith(
          quantityOperationStatus: QuantityOperationStatus.failure,
          quantityOperationError: "Cart is empty",
        ));
        return;
      }

      // Find the cart item by product ID
      CartItem? cartItem;
      for (final item in state.cart!.items!) {
        if (item.product?.id == event.product.id) {
          cartItem = item;
          break;
        }
      }

      if (cartItem == null) {
        emit(state.copyWith(
          quantityOperationStatus: QuantityOperationStatus.failure,
          quantityOperationError: "Item not found in cart",
        ));
        return;
      }

      // Check inventory limit
      final int currentQuantity = cartItem.quantity ?? 0;
      final int availableInventory = event.product.inventory ?? 0;

      if (currentQuantity >= availableInventory) {
        emit(state.copyWith(
          quantityOperationStatus: QuantityOperationStatus.failure,
          quantityOperationError:
              "Cannot exceed available inventory ($availableInventory)",
          operatingItemId: cartItem.id,
        ));
        return;
      }

      // Emit updating state
      emit(state.copyWith(
        quantityOperationStatus: QuantityOperationStatus.updating,
        operatingItemId: cartItem.id,
      ));

      // Make API call
      Either response = await sl<UpdateCartItemQuantityUseCase>().call(
        params: UpdateCartItemQuantityParams(
          cartId: state.cart?.id,
          cartItemId: cartItem.id,
          quantity: currentQuantity + 1,
        ),
      );

      response.fold((error) {
        emit(state.copyWith(
          quantityOperationStatus: QuantityOperationStatus.failure,
          quantityOperationError: error,
        ));
      }, (data) {
        final updatedItems = state.cart?.items?.map((item) {
          if (item.product?.id == event.product.id) {
            final newQuantity = (item.quantity ?? 0) + 1;
            final newSubTotal =
                (event.product.discountedPrice ?? 0) * newQuantity;
            return item.copyWith(
              quantity: newQuantity,
              subTotal: newSubTotal,
            );
          }
          return item;
        }).toList();

        // Calculate new cart total
        final newCartTotal = updatedItems?.fold<double>(
          0.0,
          (total, item) => total + (item.subTotal ?? 0),
        );

        final updatedCart = state.cart?.copyWith(
          items: updatedItems,
          cartTotal: newCartTotal,
        );

        emit(state.copyWith(
          cart: updatedCart,
          quantityOperationStatus: QuantityOperationStatus.success,
        ));
      });
    });
  }

  void _onAddProductToCartPage(
      AddProductToCartPageEvent event, Emitter<CartState> emit) async {
    // check if item is in the cart List
    List<CartItem> updateCartList = List.from(state.cart?.items ?? []);

    for (var cartItem in state.cart?.items ?? []) {
      if (cartItem.product?.id == event.cartItem.product?.id) {
        // if product exist in cart List get the index of the item
        int? index = state.cart?.items?.indexWhere(
            (item) => item.product?.id == event.cartItem.product?.id);

        // update the quantity of the cart item using its index
        state.cart?.items?[index ?? 0].quantity = event.cartItem.quantity;

        num cartTotal = state.cart?.cartTotal ?? 0;
        num productSubTotal =
            event.quantityToAdd * event.cartItem.product!.discountedPrice!;
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
        (event.cartItem.product!.discountedPrice! * event.quantityToAdd);
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
        (cartItemtoRemove.product!.discountedPrice! *
            cartItemtoRemove.quantity!);

    List<CartItem> updatedCartList = List.from(state.cart!.items!)
      ..removeWhere((cartItem) => cartItem.product?.id == event.cartItemId);

    final newCartTotal = state.cart!.cartTotal! - cartItemtoRemoveTotalPrice;

    CartModel cart = CartModel(
        id: state.cart?.id, cartTotal: newCartTotal, items: updatedCartList);

    emit(state.copyWith(cart: cart));
  }

  void _onGetCart(GetCartEvent event, Emitter<CartState> emit) async {
    emit(const CartState());
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
}
