part of 'favorite_bloc.dart';

// enum
enum FavoriteProductsStatus { initial, success, failure }

enum AddToFavoriteStatus { initial, loading, favorited, unfavorited, failure }

// enum
enum FavoriteProductSort { intial, asc, desc }

final class FavoriteState extends Equatable {
  final FavoriteProductSort favoriteProductSort;
  final AddToFavoriteStatus addToFavoriteStatus;
  final FavoriteProductsStatus status;
  final String? errorMessage;
  final bool isFetching;
  final bool hasReachedMax;
  final int page;
  final List<FavoriteProductResult> favoriteProducts;
  final Set<String> favoriteProductIds;
  final Map<String, bool> loadingStates;

  const FavoriteState(
      {this.favoriteProductSort = FavoriteProductSort.intial,
      this.status = FavoriteProductsStatus.initial,
      this.errorMessage,
      this.isFetching = false,
      this.hasReachedMax = false,
      this.page = 1,
      this.addToFavoriteStatus = AddToFavoriteStatus.initial,
      this.favoriteProducts = const <FavoriteProductResult>[],
      this.loadingStates = const <String, bool>{},
      this.favoriteProductIds = const <String>{}});

  bool isFavorite(String productId) {
    return favoriteProductIds.contains(productId);
  }

   bool isProductLoading(String productId) {
    return loadingStates[productId] ?? false;
  }

  @override
  List<Object?> get props => [
        favoriteProductSort,
        status,
        errorMessage,
        isFetching,
        hasReachedMax,
        favoriteProducts,
        addToFavoriteStatus,
        favoriteProductIds,
        loadingStates,
      ];

  FavoriteState copyWith({
    FavoriteProductSort? favoriteProductSort,
    FavoriteProductsStatus? status,
    String? errorMessage,
    bool? isFetching,
    bool? hasReachedMax,
    int? page,
    List<FavoriteProductResult>? favoriteProducts,
    AddToFavoriteStatus? addToFavoriteStatus,
    Set<String>? favoriteProductIds,
    Map<String, bool>? loadingStates,
  }) {
    return FavoriteState(
      favoriteProductSort: favoriteProductSort ?? this.favoriteProductSort,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isFetching: isFetching ?? this.isFetching,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      addToFavoriteStatus: addToFavoriteStatus ?? this.addToFavoriteStatus,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
      loadingStates: loadingStates ?? this.loadingStates,
    );
  }
}
