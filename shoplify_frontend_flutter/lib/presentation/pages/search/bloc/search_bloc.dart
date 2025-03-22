import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/data/models/search_params_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<UpdateSearchText>(_onSearchTextUpdate);
    on<SearchProductEvent>(_onSearchProduct);
    on<ResetSearchEvent>(_resetSearchEvent);
  }

  void _onSearchTextUpdate(UpdateSearchText event, Emitter<SearchState> emit) {
    emit(state.copyWith(searchText: event.text));
  }

  void _resetSearchEvent(ResetSearchEvent event, Emitter<SearchState> emit) {
    emit(state.copyWith(
        errorMessage: null,
        hasReachedMax: false,
        isFetching: false,
        page: 1,
        searchResultProducts: [],
        searchStatus: SearchStatus.initial));
  }

  void _onSearchProduct(
      SearchProductEvent event, Emitter<SearchState> emit) async {
    if (state.isFetching || state.hasReachedMax) return;

    try {
      emit(state.copyWith(isFetching: true));

      final Either response = await sl<SearchProductUseCase>().call(
          params:
              // use the params from the filter bottomsheet if true
              event.useFilterParams
                  ? event.searchParamsModel
                  : SearchParamsModel(
                      searchText: event.searchParamsModel.searchText,
                      page: state.page));

      response.fold((error) {
        emit(state.copyWith(
            errorMessage: error.toString(),
            isFetching: false,
            hasReachedMax: false,
            searchStatus: SearchStatus.failure));
      }, (data) {
        final String? nextPage = data["next"];
        final List<ProductModelEntity> searchProductResult =
            List.from(data["results"])
                .map((e) => ProductModel.fromMap(e).toEntity())
                .toList();

        if (searchProductResult.isEmpty) {
          emit(state.copyWith(
              searchStatus: SearchStatus.success,
              hasReachedMax: true,
              isFetching: false));

          return;
        }
        // Increment page only if data is fetched
        emit(state.copyWith(
            searchStatus: SearchStatus.success,
            searchResultProducts: [
              ...state.searchResultProducts,
              ...searchProductResult
            ],
            page: state.page + 1,
            hasReachedMax: nextPage != null ? false : true,
            isFetching: false));

        return;
      });
    } catch (e) {
      emit(state.copyWith(
          searchStatus: SearchStatus.failure,
          errorMessage: e.toString(),
          isFetching: false));
    }
  }
}
