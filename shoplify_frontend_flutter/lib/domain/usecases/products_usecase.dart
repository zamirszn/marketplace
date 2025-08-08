import 'package:dartz/dartz.dart';
import 'package:shoplify/core/usecase/usecase.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/domain/repository/products_repo.dart';
import 'package:shoplify/domain/repository/review_repo.dart';
import 'package:shoplify/presentation/service_locator.dart';

class GetProductCategoryUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<ProductsRepository>().getProductCategories();
  }
}

class GetNewProductsUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<ProductsRepository>().getNewProducts();
  }
}

class GetPopularProductUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<ProductsRepository>().getPopularProducts();
  }
}

class SearchProductUseCase implements Usecase<Either, SearchParamsModel> {
  @override
  Future<Either> call({SearchParamsModel? params}) async {
    return sl<ProductsRepository>().searchProduct(params!);
  }
}

class GetAllProductUseCase implements Usecase<Either, ProductQueryParamsModel> {
  @override
  Future<Either> call({ProductQueryParamsModel? params}) async {
    return sl<ProductsRepository>().getAllProducts(params!);
  }
}

class AddToCartUseCase implements Usecase<Either, AddToCartParamsModel> {
  @override
  Future<Either> call({AddToCartParamsModel? params}) async {
    return sl<ProductsRepository>().addToCart(params!);
  }
}

class AddtoFavoriteUseCase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<ProductsRepository>().addToFavorite(params!);
  }
}

class RefreshProductDetails implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<ProductsRepository>().refreshProductDetails(params!);
  }
}

class RemovefromFavoriteUseCase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<ProductsRepository>().removeToFavorite(params!);
  }
}

class GetorCreateCartUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<ProductsRepository>().getOrCreateCart();
  }
}

class GetCartIdUseCase implements Usecase<String?, dynamic> {
  @override
  Future<String?> call({params}) async {
    return sl<ProductsRepository>().getCartId();
  }
}

class GetReviewsUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<ReviewRepository>().getProductReviews(params!);
  }
}

class SubmitReviewUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<ReviewRepository>().submitProductReview(params!);
  }
}

class RemoveFromCartUseCase
    implements Usecase<Either, RemoveFromCartModelParams> {
  @override
  Future<Either> call({RemoveFromCartModelParams? params}) async {
    return sl<ProductsRepository>().removeFromCart(params!);
  }
}
