import 'package:dartz/dartz.dart';
import 'package:shoplify/data/models/add_to_cart_params_model.dart';
import 'package:shoplify/data/models/cart_model.dart';
import 'package:shoplify/data/models/product_query_params_model.dart';
import 'package:shoplify/data/models/search_params_model.dart';

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
