import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'new_product_event.dart';
part 'new_product_state.dart';

class NewProductBloc extends Bloc<NewProductEvent, NewProductState> {
  NewProductBloc() : super(NewProductInitial()) {
    on<GetNewProductsEvent>(_onGetNewProducts);
  }

  void _onGetNewProducts(
      GetNewProductsEvent event, Emitter<NewProductState> emit) async {
    emit(NewProductLoading());
    Either response = await sl<GetNewProductsUseCase>().call();
    response.fold((error) {
      emit(NewProductFailure(message: error.toString()));
    }, (data) {
      List<ProductModelEntity> newProducts = List.from(data)
          .map((e) => ProductModel.fromMap(e).toEntity())
          .toList();
      if (newProducts.isEmpty) {
        emit(NewProductEmpty());
      } else {
        emit(NewProductSuccess(newProducts: newProducts));
      }
    });
  }
}
