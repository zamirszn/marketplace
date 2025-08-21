import 'package:dartz/dartz.dart';
import 'package:shoplify/data/models/params_models.dart';

abstract class ProductsRepository {
  Future<Either> getProductCategories();
  Future<Either> getNewProducts();
  Future<Either> getPopularProducts();
  Future<Either> getAllProducts(ProductQueryParamsModel params);
  Future<Either> searchProduct(SearchParamsModel params);
  Future<Either> addToCart(AddToCartParamsModel params);
  Future<Either> getOrCreateCart();
  Future<Either> updateCartItemQuantity(UpdateCartItemQuantityParams params);
  Future<String?> getCartId();
  Future<Either> addToFavorite(String productId);
  Future<Either> removeToFavorite(String productId);
  Future<Either> refreshProductDetails(String productId);
  Future<Either> removeFromCart(RemoveFromCartModelParams params);
  Future<Either> getFavoriteProducts(FavoriteProductParamsModel params);
  Future<Either> getMyOrder(GetMyOrderParams params);
}
