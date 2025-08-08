import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/data/models/response_models.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'all_products_event.dart';
part 'all_products_state.dart';

class AllProductsBloc extends Bloc<AllProductsEvent, AllProductsState> {
  AllProductsBloc() : super(const AllProductsState()) {
    on<ResetAllProductListEvent>((event, emit) async {
      emit(const AllProductsState());
    });

    on<GetAllProductsEvent>((event, emit) async {
      if (state.isFetching || state.hasReachedMax) {
        return;
      }
      

      emit(state.copyWith(
        isFetching: true,
      ));

      

      Either response =
          await sl<GetAllProductUseCase>().call(params: event.params);

      response.fold((error) {
        emit(state.copyWith(
          errorMessage: error,
          hasReachedMax: false,
          isFetching: false,
          allProductsListStatus: AllProductsListStatus.failure,
        ));
      }, (data) {
        final AllProductresponseModel response =
            AllProductresponseModel.fromMap(data);
        final bool hasNextPage = response.next != null;
        List<Product>? fetchedProductsList = response.results;

        if (fetchedProductsList != null && fetchedProductsList.isEmpty) {
          emit(state.copyWith(
            allProductsListStatus: AllProductsListStatus.success,
            hasReachedMax: true,
            isFetching: false,
          ));
          return;
        }

        emit(state.copyWith(
          allProductsListStatus: AllProductsListStatus.success,

          productsList: [...state.productsList, ...fetchedProductsList ?? []],
          page: state.page + 1, // Increment page here
          hasReachedMax: hasNextPage == true ? false : true,
          isFetching: false, // Stop fetching
        ));
        return;
      });
    });
  }
}
