part of 'favorite_bloc.dart';

// enum
enum FavoriteProductStatus { initial, success, failure }

// enum
enum FavoriteProductSort { intial, asc, desc }



final class FavoriteState extends Equatable {
  final FavoriteProductSort favoriteProductSort;
  final FavoriteProductStatus status;
  final String? errorMessage;
  final bool isFetching;
  final bool hasReachedMax;
  final int page;
  final List<ProductModelEntity> favoriteProducts;

  const FavoriteState(
      {this.favoriteProductSort = FavoriteProductSort.intial,
      this.status = FavoriteProductStatus.initial,
      this.errorMessage,
      this.isFetching = false,
      this.hasReachedMax = false,
      this.page = 1,
      this.favoriteProducts = const <ProductModelEntity>[]});

  @override
  List<Object?> get props => [
        favoriteProductSort,
        status,
        errorMessage,
        isFetching,
        hasReachedMax,
        favoriteProducts,
      ];

  FavoriteState copyWith({
    FavoriteProductSort? favoriteProductSort,
    FavoriteProductStatus? status,
    String? errorMessage,
    bool? isFetching,
    bool? hasReachedMax,
    int? page,
    List<ProductModelEntity>? favoriteProducts,
  }) {
    return FavoriteState(
        favoriteProductSort: favoriteProductSort ?? this.favoriteProductSort,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        isFetching: isFetching ?? this.isFetching,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
        favoriteProducts: favoriteProducts ?? this.favoriteProducts);
  }
}


