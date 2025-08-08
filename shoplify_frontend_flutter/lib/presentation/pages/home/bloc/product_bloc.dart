import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shoplify/data/models/cart_model.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<GetOrCreateCartEvent>(_getOrCreateCart);
    on<ToggleFavoriteEvent>(_toggleProductToFavorite);
  }

  void _toggleProductToFavorite(
      ToggleFavoriteEvent event, Emitter<ProductState> emit) async {
    emit(AddToFavoriteLoading());

    final Either response = event.isCurrentlyFavorited
        ? await sl<RemovefromFavoriteUseCase>().call(params: event.productId)
        : await sl<AddtoFavoriteUseCase>().call(params: event.productId);

    response.fold((error) {
      emit(AddToFavoriteFailure(message: error.toString()));
    }, (data) {
      // product was removed from favorites

      if (data["product"] != null) {
        final Product product =
            Product.fromMap(data["product"]);

        emit(ToggleFavoriteAddSuccess(
          message: data["message"],
          product: product,
          isFavorited: event.isCurrentlyFavorited,
        ));
      } else {
        // product was removed from favorites
        emit(ToggleFavoriteRemoveSuccess(
          message: data["message"],
        ));
      }
    });
  }

  void _getOrCreateCart(
      GetOrCreateCartEvent event, Emitter<ProductState> emit) async {
    emit(CreateorGetCartLoading());
    Either response = await sl<GetorCreateCartUseCase>().call();
    response.fold((error) {
      emit(CreateorGetCartFailure(errorMessage: error.toString()));
    }, (data) {
      final CartModel cart = CartModel.fromMap(data);
      emit(CreateorGetCartSuccess(cart: cart));
    });
  }

  void _onAddToCart(AddToCartEvent event, Emitter<ProductState> emit) async {
    emit(AddToCartLoading());
    Either response = await sl<AddToCartUseCase>().call(params: event.params);
    response.fold((error) {
      emit(AddToCartFailure());
    }, (data) {
      final CartItem cartItem = CartItem.fromMap(data);
      emit(AddToCartSuccess(cartItemToAdd: cartItem));
    });
  }
}
