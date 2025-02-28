import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(const ProductDetailsState()) {
    on<SetProductDetailsEvent>(_onSetProductDetails);
    on<RefreshProductDetailsEvent>(_onRefreshProductDetails);
  }

  _onSetProductDetails(
      SetProductDetailsEvent event, Emitter<ProductDetailsState> emit) {
    emit(state.copyWith(selectedProduct: event.product));
  }

  _onRefreshProductDetails(RefreshProductDetailsEvent event,
      Emitter<ProductDetailsState> emit) async {
    final Either response =
        await sl<RefreshProductDetails>().call(params: event.productId);
    response.fold(
      (error) {
        // do nothing
      },
      (data) {
        final ProductModelEntity product =
            ProductModel.fromMap(data).toEntity();
        emit(state.copyWith(
            selectedProduct: product, status: ProductDetailsStatus.success));
        print("refreshing");
      },
    );
  }
}
