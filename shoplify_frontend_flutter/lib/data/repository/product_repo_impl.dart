import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/source/products_service_data_source.dart';
import 'package:shoplify/domain/repository/products_repo.dart';
import 'package:shoplify/presentation/service_locator.dart';

class ProductRepositoryImpl extends ProductsRepository {
  @override
  Future<Either> getProductCategories() async {
    Either result =
        await sl<ProductsServiceDataSource>().getProductCategories();
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> getNewProducts() async {
    Either result = await sl<ProductsServiceDataSource>().getNewProducts();
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> getPopularProducts() async {
    Either result = await sl<ProductsServiceDataSource>().getPopularProducts();
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> getAllProducts(ProductQueryParamsModel params) async {
    Either result =
        await sl<ProductsServiceDataSource>().getAllProducts(params);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> addToCart(AddToCartParamsModel params) async {
    Either result = await sl<ProductsServiceDataSource>().addToCart(params);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> addToFavorite(String productId) async {
    Either result =
        await sl<ProductsServiceDataSource>().addToFavorite(productId);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> removeToFavorite(String productId) async {
    Either result =
        await sl<ProductsServiceDataSource>().removeToFavorite(productId);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  String? _cartId;

  @override
  Future<String?> getCartId() async {
    return _cartId;
  }

  @override
  Future<Either> getOrCreateCart() async {
    Either result = await sl<ProductsServiceDataSource>().getOrCreateCart();
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      _cartId = response.data["id"];
      return Right(response.data);
    });
  }

  @override
  Future<Either> refreshProductDetails(String productId) async {
    Either result =
        await sl<ProductsServiceDataSource>().refreshProductDetails(productId);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> removeFromCart(RemoveFromCartModelParams params) async {
    Either result =
        await sl<ProductsServiceDataSource>().removeFromCart(params);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> searchProduct(SearchParamsModel params) async {
    Either result = await sl<ProductsServiceDataSource>().searchProduct(params);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }
  
  @override
  Future<Either> getFavoriteProducts(FavoriteProductParamsModel params)async {
        Either result = await sl<ProductsServiceDataSource>().getFavoriteProducts(params);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  
  
  @override
  Future<Either> getMyOrder(GetMyOrderParams params)async {
      Either result = await sl<ProductsServiceDataSource>().getMyOrder(params);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }
  
  @override
  Future<Either> updateCartItemQuantity(UpdateCartItemQuantityParams params)async {
      Either result = await sl<ProductsServiceDataSource>().updateCartItemQuantity(params);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }
}
