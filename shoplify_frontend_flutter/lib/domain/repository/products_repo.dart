import 'package:dartz/dartz.dart';
import 'package:shoplify/data/models/params_models.dart';


abstract class ProductsRepository {
  Future<Either> getProductCategories();
  Future<Either> getNewProducts();
  Future<Either> getPopularProducts();
  Future<Either> getAllProducts(ProductQueryParamsModel productQueryParams);
  Future<Either> searchProduct(SearchParamsModel searchParamsModel);
  Future<Either> addToCart(AddToCartParamsModel addToCartParams);
  Future<Either> getOrCreateCart();
  Future<String?> getCartId();
  Future<Either> addToFavorite(String productId);
  Future<Either> removeToFavorite(String productId);
  Future<Either> refreshProductDetails(String productId);
  Future<Either> removeFromCart(RemoveFromCartModelParams removeFromCartModelParams);

}
