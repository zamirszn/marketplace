// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'all_products_bloc.dart';

enum AllProductsListStatus { initial, success, failure }

class AllProductsState extends Equatable {
  final bool hasReachedMax;
  final String? errorMessage;
  final String? successMessage;
  final bool isFetching;
  final int page;
  final AllProductsListStatus allProductsListStatus;
  final List<Product> productsList;
  final String? viewProductImageUrl;

  const AllProductsState({
    this.hasReachedMax = false,
    this.viewProductImageUrl,
    this.errorMessage,
    this.successMessage,
    this.isFetching = false,
    this.page = 1,
    this.allProductsListStatus = AllProductsListStatus.initial,
    this.productsList = const [],
  });

  @override
  List<Object?> get props => [
        hasReachedMax,
        errorMessage,
        isFetching,
        page,
        successMessage,
        productsList,
        allProductsListStatus,
        viewProductImageUrl
      ];

  AllProductsState copyWith({
    String? viewProductImageUrl,
    bool? hasReachedMax,
    String? errorMessage,
    String? successMessage,
    bool? isFetching,
    int? page,
    AllProductsListStatus? allProductsListStatus,
    List<Product>? productsList,
  }) {
    return AllProductsState(
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      viewProductImageUrl: viewProductImageUrl ?? this.viewProductImageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isFetching: isFetching ?? this.isFetching,
      page: page ?? this.page,
      allProductsListStatus:
          allProductsListStatus ?? this.allProductsListStatus,
      productsList: productsList ?? this.productsList,
    );
  }
}
