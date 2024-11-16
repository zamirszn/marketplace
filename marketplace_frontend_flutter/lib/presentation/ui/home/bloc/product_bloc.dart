import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/models/add_to_cart_params_model.dart';
import 'package:marketplace/data/models/cart_model.dart';
import 'package:marketplace/data/models/product_category_model.dart';
import 'package:marketplace/data/models/product_model.dart';
import 'package:marketplace/data/models/product_query_params_model.dart';
import 'package:marketplace/domain/entities/product_category_entity.dart';
import 'package:marketplace/domain/entities/product_entity.dart';
import 'package:marketplace/domain/usecases/products_usecase.dart';
import 'package:marketplace/presentation/service_locator.dart';
import 'package:marketplace/presentation/ui/home/home_page.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<GetProductCategoryEvent>(_onGetProductsGategory);
    on<GetNewProductsEvent>(_onGetNewProducts);
    on<GetPopularProductsEvent>(_onGetPopularProducts);
    on<GetAllProductsEvent>(_onGetAllProducts);
    on<AddToCartEvent>(_onAddToCart);
    on<CreateorGetCartEvent>(_getOrCreateCart);
  }

  _getOrCreateCart(
      CreateorGetCartEvent event, Emitter<ProductState> emit) async {
    emit(CreateorGetCartLoading());
    Either response = await sl<GetorCreateCartUseCase>().call();
    response.fold((error) {
      emit(CreateorGetCartFailure(message: error.toString()));
    }, (data) {
      final CartModel cart = CartModel.fromMap(data);
      emit(CreateorGetCartSuccess(cart: cart));
    });
  }

  _onAddToCart(AddToCartEvent event, Emitter<ProductState> emit) async {
    emit(AddToCartLoading());
    Either response = await sl<AddToCartUseCase>().call(params: event.params);
    response.fold((error) {
      emit(AddToCartFailure());
    }, (data) {
      emit(AddToCartSuccess());
    });
  }

  _onGetAllProducts(
      GetAllProductsEvent event, Emitter<ProductState> emit) async {
    if (!_hasReachedMax(state)) {
      try {
        if (state is ProductInitial || state is AllProductLoading) {
          // initial load
          emit(AllProductLoading());
          Either response =
              await sl<GetAllProductUseCase>().call(params: event.params);

          response.fold((error) {
            emit(AllProductFailure());
          }, (data) {
            List<ProductModelEntity> products = List.from(data["results"])
                .map((e) => ProductModel.fromMap(e).toEntity())
                .toList();
            emit(AllProductSuccess(hasReachedMax: false, products: products));
          });
        } else if (state is AllProductSuccess) {
          final currentState = state as AllProductSuccess;

          Either response =
              await sl<GetAllProductUseCase>().call(params: event.params);
          response.fold((error) {
            emit(AllProductFailure());
          }, (data) {
            List<ProductModelEntity> products = List.from(data)
                .map((e) => ProductModel.fromMap(e).toEntity())
                .toList();
            if (products.isEmpty) {
              emit(currentState.copyWith(hasReachedMax: true));
            } else {
              emit(AllProductSuccess(
                  hasReachedMax: false,
                  products: currentState.products + products));
            }
          });
        }
      } catch (e) {
        emit(AllProductFailure());
      }
    }
  }

  bool _hasReachedMax(ProductState state) =>
      state is AllProductSuccess && state.hasReachedMax;
}

_onGetNewProducts(GetNewProductsEvent event, Emitter<ProductState> emit) async {
  emit(NewProductLoading());
  Either response = await sl<GetNewProductsUseCase>().call();
  response.fold((error) {
    emit(NewProductFailure());
  }, (data) {
    List<ProductModelEntity> newProducts =
        List.from(data).map((e) => ProductModel.fromMap(e).toEntity()).toList();
    emit(NewProductSuccess(newProducts: newProducts));
  });
}

_onGetProductsGategory(
    GetProductCategoryEvent event, Emitter<ProductState> emit) async {
  emit(ProductCategoryLoading());
  Either response = await sl<GetProductCategoryUsecase>().call();
  response.fold((error) {
    emit(ProductCategoryFailure());
  }, (data) {
    List<ProductCategoryEntity> categories = List.from(data)
        .map((e) => ProductCategoryModel.fromMap(e).toEntity())
        .toList();
    emit(ProductCategorySuccess(productCategories: categories));
  });
}

_onGetPopularProducts(
    GetPopularProductsEvent event, Emitter<ProductState> emit) async {
  emit(PopularProductLoading());
  Either response = await sl<GetPopularProductUseCase>().call();
  response.fold(((error) {
    emit(PopularProductFailure());
  }), (data) {
    List<ProductModelEntity> popualarProducts =
        List.from(data).map((e) => ProductModel.fromMap(e).toEntity()).toList();

    emit(PopularProductSuccess(popularProducts: popualarProducts));
  });
}