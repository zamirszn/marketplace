import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:marketplace/data/models/product_category_model.dart';
import 'package:marketplace/domain/entities/product_category_entity.dart';
import 'package:marketplace/domain/usecases/products_usecase.dart';
import 'package:marketplace/presentation/service_locator.dart';
import 'package:meta/meta.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    on<GetProductCategoryEvent>(_onGetProductsGategory);
  }

  _onGetProductsGategory(
      GetProductCategoryEvent event, Emitter<HomePageState> emit) async {
    emit(HomePageCategoryLoading());
    Either response = await sl<ProductsUsecase>().call();
    response.fold((error) {
      emit(HomePageCategoryFailure());
    }, (data) {
      List<ProductCategoryEntity> categories = List.from(data)
          .map((e) => ProductCategoryModel.fromMap(e).toEntity())
          .toList();
      emit(HomePageCategorySuccess(productCategories: categories));
    });
    
  }
}
