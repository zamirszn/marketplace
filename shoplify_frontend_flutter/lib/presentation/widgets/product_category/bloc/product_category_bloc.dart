import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/product_category_model.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'product_category_event.dart';
part 'product_category_state.dart';

class ProductCategoryBloc
    extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  ProductCategoryBloc() : super(ProductCategoryInitial()) {
    on<GetProductCategoryEvent>(_onGetProductsGategory);
  }
}

void _onGetProductsGategory(
    GetProductCategoryEvent event, Emitter<ProductCategoryState> emit) async {
  emit(ProductCategoryLoading());
  Either response = await sl<GetProductCategoryUsecase>().call();
  response.fold((error) {
    emit(ProductCategoryFailure());
  }, (data) {
    List<ProductCategory> categories = List.from(data)
        .map((e) => ProductCategory.fromMap(e))
        .toList();
    emit(ProductCategorySuccess(productCategories: categories));
  });
}
