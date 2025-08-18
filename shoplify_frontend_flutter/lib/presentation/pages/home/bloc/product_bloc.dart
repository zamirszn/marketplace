import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/cart_model.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<GetOrCreateCartEvent>(_getOrCreateCart);
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
}
