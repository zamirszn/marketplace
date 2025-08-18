import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/favorite_product_model.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/data/models/response_models.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState()) {
    on<GetFavoriteProductEvent>(_getFavoriteProduct);
    on<RefreshFavoriteProductEvent>(_refreshFavoriteProduct);
    on<RemoveFromFavoritePageEvent>(_removeFavoriteByIdEvent);
    on<AddToFavoritePageEvent>(_addToFavorite);
    on<ToggleFavoriteEvent>(_toggleProductToFavorite);
  }

  void _toggleProductToFavorite(
      ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    newLoadingStates[event.product.id!] = true;
    emit(state.copyWith(
      loadingStates: newLoadingStates,
      addToFavoriteStatus: AddToFavoriteStatus.loading,
    ));

    // if the product was previously liked unlike it
    final Either response = event.isCurrentlyFavorited
        ? await sl<RemovefromFavoriteUseCase>().call(params: event.product.id!)
        : await sl<AddtoFavoriteUseCase>().call(params: event.product.id!);

    response.fold((error) {
      newLoadingStates.remove(event.product.id!);
      emit(state.copyWith(
          addToFavoriteStatus: AddToFavoriteStatus.failure,
          errorMessage: error));
    }, (data) {
      // update loading state
      newLoadingStates.remove(event.product.id!);
      // Update both favoriteProducts list and favoriteProductIds set
      List<FavoriteProductResult> updatedFavorites =
          List.from(state.favoriteProducts);
      Set<String> updatedFavoriteIds = Set.from(state.favoriteProductIds);

      if (event.isCurrentlyFavorited) {
        // Remove from both lists
        updatedFavorites
            .removeWhere((fav) => fav.product?.id == event.product.id!);
        updatedFavoriteIds.remove(event.product.id!);

        emit(state.copyWith(
          addToFavoriteStatus: AddToFavoriteStatus.unfavorited,
          favoriteProducts: updatedFavorites,
          favoriteProductIds: updatedFavoriteIds,
        ));
      } else {
        // Add to favoriteProductIds set (favoriteProducts list will be updated when page refreshes)
        updatedFavoriteIds.add(event.product.id!);

        emit(state.copyWith(
          addToFavoriteStatus: AddToFavoriteStatus.favorited,
          favoriteProductIds: updatedFavoriteIds,
        ));

        final FavoriteProductResult? response =
            AddFavoriteResponseModel.fromMap(data).favorite;

        add(AddToFavoritePageEvent(product: response!));
      }
    });
  }

  void _addToFavorite(
      AddToFavoritePageEvent event, Emitter<FavoriteState> emit) {
    final List<FavoriteProductResult> updatedFavorites =
        List.from(state.favoriteProducts)..add(event.product);

    // Also update favoriteProductIds set
    final Set<String> updatedFavoriteIds = Set.from(state.favoriteProductIds);
    if (event.product.product?.id != null) {
      updatedFavoriteIds.add(event.product.product!.id!);
    }

    emit(state.copyWith(
      favoriteProducts: updatedFavorites,
      favoriteProductIds: updatedFavoriteIds,
      status: FavoriteProductsStatus.success,
    ));
  }

  void _removeFavoriteByIdEvent(
      RemoveFromFavoritePageEvent event, Emitter<FavoriteState> emit) {
    List<FavoriteProductResult> updatedFavoriteList =
        List.from(state.favoriteProducts)
          ..removeWhere((fav) => fav.product?.id == event.productId);

    // Also update favoriteProductIds set
    Set<String> updatedFavoriteIds = Set.from(state.favoriteProductIds);
    updatedFavoriteIds.remove(event.productId);

    emit(state.copyWith(
      favoriteProducts: updatedFavoriteList,
      favoriteProductIds: updatedFavoriteIds,
    ));
  }

  void _refreshFavoriteProduct(
      RefreshFavoriteProductEvent event, Emitter<FavoriteState> emit) async {
    emit(const FavoriteState());
    add(GetFavoriteProductEvent(
        params: FavoriteProductParamsModel(
            ordering: FavoriteProductSort.intial, page: 1)));
  }

  void _getFavoriteProduct(
      GetFavoriteProductEvent event, Emitter<FavoriteState> emit) async {
    if (state.isFetching || state.hasReachedMax) {
      return;
    }

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
          status: FavoriteProductsStatus.failure));
      // Stop fetching
    }, (data) {
      final FavoriteProductsResponseModel response =
          FavoriteProductsResponseModel.fromMap(data);
      final List<FavoriteProductResult>? fetchedFavoriteProducts =
          response.results;

      final String? nextPage = response.next;

      // If no favorites are fetched, stop pagination
      if (fetchedFavoriteProducts != null && fetchedFavoriteProducts.isEmpty) {
        emit(
          state.copyWith(
              status: FavoriteProductsStatus.success,
              hasReachedMax: true,
              isFetching: false),
        );

        return;
      }

      final Set<String> allFavoriteIds = Set.from(state.favoriteProductIds);
      for (var fav in fetchedFavoriteProducts ?? []) {
        if (fav.product?.id != null) {
          allFavoriteIds.add(fav.product!.id!);
        }
      }

      // Increment page only if data is fetched
      emit(state.copyWith(
        status: FavoriteProductsStatus.success,
        favoriteProducts: [
          ...state.favoriteProducts,
          ...fetchedFavoriteProducts ?? []
        ],
        favoriteProductIds: allFavoriteIds,
        page: state.page + 1, // Increment page here
        hasReachedMax: nextPage != null ? false : true,
        isFetching: false, //stop fetching
      ));
      return;
    });
  }
}
