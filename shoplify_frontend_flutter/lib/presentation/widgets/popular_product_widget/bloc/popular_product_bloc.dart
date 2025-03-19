import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'popular_product_event.dart';
part 'popular_product_state.dart';

class PopularProductBloc
    extends Bloc<PopularProductEvent, PopularProductState> {
  PopularProductBloc() : super(PopularProductInitial()) {
    on<GetPopularProductsEvent>(_onGetPopularProducts);
  }

  void _onGetPopularProducts(
      GetPopularProductsEvent event, Emitter<PopularProductState> emit) async {
    emit(PopularProductLoading());
    Either response = await sl<GetPopularProductUseCase>().call();
    response.fold(((error) {
      emit(PopularProductFailure(message: error.toString()));
    }), (data) {
      List<ProductModelEntity> popualarProducts = List.from(data)
          .map((e) => ProductModel.fromMap(e).toEntity())
          .toList();
      if (popualarProducts.isEmpty) {
        emit(PopularProductEmpty());
      } else {
        emit(PopularProductSuccess(popularProducts: popualarProducts));
      }
    });
  }
}
