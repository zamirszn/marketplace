import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/favorite_product_model.dart';
import 'package:shoplify/data/models/favorite_product_params_model.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/domain/usecases/favorite_products.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState()) {
    on<GetFavoriteProductEvent>(_getFavoriteProduct);
    on<RefreshFavoriteProductEvent>(_refreshFavoriteProduct);
    // on<RemoveFromFavoriteEvent>(_removeFromFavorite);
  }

  // void _removeFromFavorite(
  //     RemoveFromFavoriteEvent event, Emitter<FavoriteState> emit) {
  //   emit(RemoveFromFavoriteLoading());
  //   print(state.favoriteProducts.length);

  // state.favoriteProducts
  //     .removeWhere((product) => product.id == event.productId);
  // print(state.favoriteProducts.length);
  // }

  void _refreshFavoriteProduct(
      RefreshFavoriteProductEvent event, Emitter<FavoriteState> emit) async {
    if (state.isFetching) {
      return;
    }
    emit(state.copyWith(
        errorMessage: null,
        page: 1,
        favoriteProductSort: FavoriteProductSort.intial,
        favoriteProducts: [],
        hasReachedMax: false,
        isFetching: true,
        status: FavoriteProductStatus.initial));
    // start fetching

    final Either response =
        await sl<GetFavoriteProductUseCase>().call(params: event.params);

    response.fold((error) {
      // Handle failure, no page increment
      emit(state.copyWith(
          errorMessage: error.toString(),
          isFetching: false,
          hasReachedMax: false,
          status: FavoriteProductStatus.failure));

      // stop fetching
    }, (data) {
      final List<ProductModelEntity> fetchedFavoriteProducts =
          List.from(data["results"])
              .map((e) => FavoriteProductResult.fromMap(e).product!.toEntity())
              .toList();

      // if the data is empty
      if (fetchedFavoriteProducts.isEmpty) {
        emit(state.copyWith(
            status: FavoriteProductStatus.success,
            hasReachedMax: true,
            isFetching: false));

        return;
      }

      emit(state.copyWith(
        status: FavoriteProductStatus.success,
        favoriteProducts: fetchedFavoriteProducts,
        page: state.page,
        hasReachedMax: false,
        isFetching: false,
      ));
    });
  }

  void _getFavoriteProduct(
      GetFavoriteProductEvent event, Emitter<FavoriteState> emit) async {
    if (state.isFetching || state.hasReachedMax) {
      return;
    }

    try {
      emit(state.copyWith(isFetching: true));
      FavoriteProductParamsModel requestParams = FavoriteProductParamsModel(
          page: state.page, ordering: event.params.ordering);

      final Either response =
          await sl<GetFavoriteProductUseCase>().call(params: requestParams);

      response.fold((error) {
        emit(state.copyWith(
            errorMessage: error.toString(),
            isFetching: false,
            hasReachedMax: false,
            status: FavoriteProductStatus.failure));
        // Stop fetching
      }, (data) {
        final String? nextPage = data["next"];

        final List<ProductModelEntity> fetchedFavoriteProducts = List.from(
                data["results"])
            .map((e) => FavoriteProductResult.fromMap(e).product!.toEntity())
            .toList();
        // fix null here TODO:

        // If no favorites are fetched, stop pagination
        if (fetchedFavoriteProducts.isEmpty) {
          emit(
            state.copyWith(
                status: FavoriteProductStatus.success,
                hasReachedMax: true,
                isFetching: false),
          );

          return;
        }

        // Increment page only if data is fetched
        emit(state.copyWith(
          status: FavoriteProductStatus.success,
          favoriteProducts: [
            ...state.favoriteProducts,
            ...fetchedFavoriteProducts
          ],
          page: state.page + 1, // Increment page here
          hasReachedMax: nextPage != null ? false : true,
          isFetching: false, //stop fetching
        ));
        print("state page is ${state.page}");
        return;
      });
    } catch (e) {
      emit(state.copyWith(
        status: FavoriteProductStatus.failure,
        errorMessage: e.toString(),
        isFetching: false, //stop fetching
      ));
    }
  }
}
