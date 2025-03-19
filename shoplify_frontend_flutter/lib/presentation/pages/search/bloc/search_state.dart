// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

enum SearchStatus { initial, success, failure }

class SearchState extends Equatable {
  final String searchText;
  final SearchStatus searchStatus;
  final String? errorMessage;
  final bool isFetching;
  final bool hasReachedMax;
  final int page;
  final List<ProductModelEntity> searchResultProducts;

  const SearchState({
    this.searchText = "",
    this.searchStatus = SearchStatus.initial,
    this.searchResultProducts = const <ProductModelEntity>[],
    this.errorMessage,
    this.isFetching = false,
    this.hasReachedMax = false,
    this.page = 1,
  });

  @override
  List<Object?> get props => [
        searchText,
        searchStatus,
        searchResultProducts,
        errorMessage,
        isFetching,
        hasReachedMax,
        page
      ];

  

  SearchState copyWith({
    String? searchText,
    SearchStatus? searchStatus,
    String? errorMessage,
    bool? isFetching,
    bool? hasReachedMax,
    int? page,
    List<ProductModelEntity>? searchResultProducts,
  }) {
    return SearchState(
      searchText: searchText ?? this.searchText,
      searchStatus: searchStatus ?? this.searchStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFetching: isFetching ?? this.isFetching,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      searchResultProducts: searchResultProducts ?? this.searchResultProducts,
    );
  }
}
