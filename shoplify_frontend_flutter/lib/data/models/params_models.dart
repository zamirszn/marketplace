import 'dart:convert';

import 'package:shoplify/presentation/pages/favorite/bloc/favorite_bloc.dart';

class UpdateCartItemQuantityParams {
  final int quantity;
  final String? cartId;
  final int? cartItemId;
  UpdateCartItemQuantityParams({
    required this.quantity,
    this.cartId,
    this.cartItemId,
  });

  UpdateCartItemQuantityParams copyWith({
    int? quantity,
    String? cartId,
    int? cartItemId,
  }) {
    return UpdateCartItemQuantityParams(
      quantity: quantity ?? this.quantity,
      cartId: cartId ?? this.cartId,
      cartItemId: cartItemId ?? this.cartItemId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
    };
  }

  factory UpdateCartItemQuantityParams.fromMap(Map<String, dynamic> map) {
    return UpdateCartItemQuantityParams(
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateCartItemQuantityParams.fromJson(String source) =>
      UpdateCartItemQuantityParams.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UpdateCartItemQuantityParams(quantity: $quantity, cartId: $cartId, cartItemId: $cartItemId)';

  @override
  bool operator ==(covariant UpdateCartItemQuantityParams other) {
    if (identical(this, other)) return true;

    return other.quantity == quantity &&
        other.cartId == cartId &&
        other.cartItemId == cartItemId;
  }

  @override
  int get hashCode => quantity.hashCode ^ cartId.hashCode ^ cartItemId.hashCode;
}

class AddToCartParamsModel {
  final String productId;
  final int quantity;

  AddToCartParamsModel({required this.productId, required this.quantity});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
    };
  }

  factory AddToCartParamsModel.fromMap(Map<String, dynamic> map) {
    return AddToCartParamsModel(
      productId: map['product_id'] as String,
      quantity: map['quantity'] as int,
    );
  }
}

class RemoveFromCartModelParams {
  final int cartItemId;
  final String cartId;
  RemoveFromCartModelParams({
    required this.cartItemId,
    required this.cartId,
  });

  RemoveFromCartModelParams copyWith({
    int? cartItemId,
    String? cartId,
  }) {
    return RemoveFromCartModelParams(
      cartItemId: cartItemId ?? this.cartItemId,
      cartId: cartId ?? this.cartId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartItemId': cartItemId,
      'cartId': cartId,
    };
  }

  factory RemoveFromCartModelParams.fromMap(Map<String, dynamic> map) {
    return RemoveFromCartModelParams(
      cartItemId: map['cartItemId'] as int,
      cartId: map['cartId'] as String,
    );
  }

  factory RemoveFromCartModelParams.fromJson(String source) =>
      RemoveFromCartModelParams.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

// ignore_for_file: public_member_api_docs, sort_constructors_first

class LoginParamsModel {
  final String email;
  final String password;
  LoginParamsModel({
    required this.email,
    required this.password,
  });

  LoginParamsModel copyWith({
    String? email,
    String? password,
  }) {
    return LoginParamsModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  factory LoginParamsModel.fromMap(Map<String, dynamic> map) {
    return LoginParamsModel(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }
}

class ProductQueryParamsModel {
  final int? page;
  ProductQueryParamsModel({
    required this.page,
  });

  ProductQueryParamsModel copyWith({
    int? page,
  }) {
    return ProductQueryParamsModel(
      page: page ?? this.page,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
    };
  }

  factory ProductQueryParamsModel.fromMap(Map<String, dynamic> map) {
    return ProductQueryParamsModel(
      page: map['page'] as int,
    );
  }
}

class ResetPasswordParams {
  final String password;
  final int otp;
  final String email;
  ResetPasswordParams({
    required this.password,
    required this.otp,
    required this.email,
  });

  ResetPasswordParams copyWith({
    String? password,
    int? otp,
    String? email,
  }) {
    return ResetPasswordParams(
      password: password ?? this.password,
      otp: otp ?? this.otp,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'password': password,
      'otp': otp,
      'email': email,
    };
  }

  factory ResetPasswordParams.fromMap(Map<String, dynamic> map) {
    return ResetPasswordParams(
      password: map['password'] as String,
      otp: map['otp'] as int,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResetPasswordParams.fromJson(String source) =>
      ResetPasswordParams.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchParamsModel {
  final String? searchText;
  final int? page;
  final bool? discount;
  final bool? flashSale;
  final String? categoryId;
  final String? priceGreaterThan;
  final String? priceLessThan;
  final String? category;
  SearchParamsModel({
    this.searchText,
    this.page,
    this.discount,
    this.flashSale,
    this.categoryId,
    this.priceGreaterThan,
    this.priceLessThan,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'search': searchText,
      'page': page,
      'discount': discount,
      'flash_sales': flashSale,
      'category_id': categoryId,
      'old_price__gt': priceGreaterThan,
      'old_price__lt': priceLessThan,
      'category': category,
    };
  }

  factory SearchParamsModel.fromMap(Map<String, dynamic> map) {
    return SearchParamsModel(
      searchText: map['search'] as String,
      category: map['category'] as String,
      page: map['page'] != null ? map['page'] as int : null,
      discount: map['discount'] != null ? map['discount'] as bool : null,
      flashSale: map['flash_sales'] != null ? map['flash_sales'] as bool : null,
      categoryId:
          map['category_id'] != null ? map['category_id'] as String : null,
      priceGreaterThan:
          map['old_price__gt'] != null ? map['old_price__gt'] as String : null,
      priceLessThan:
          map['old_price__lt'] != null ? map['old_price__lt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchParamsModel.fromJson(String source) =>
      SearchParamsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SignupParamsModel {
  final String fullName;
  final String email;
  final String password;
  SignupParamsModel({
    required this.fullName,
    required this.email,
    required this.password,
  });

  SignupParamsModel copyWith({
    String? fullName,
    String? email,
    String? password,
  }) {
    return SignupParamsModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'password': password,
    };
  }
}

class VerifyOtpParams {
  final String email;
  final int otp;
  VerifyOtpParams({
    required this.email,
    required this.otp,
  });

  VerifyOtpParams copyWith({
    String? email,
    int? otp,
  }) {
    return VerifyOtpParams(
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'otp': otp,
    };
  }

  factory VerifyOtpParams.fromMap(Map<String, dynamic> map) {
    return VerifyOtpParams(
      email: map['email'] as String,
      otp: map['otp'] as int,
    );
  }
}

class FavoriteProductParamsModel {
  final int? page;
  final FavoriteProductSort? ordering;

  FavoriteProductParamsModel({
    this.page,
    this.ordering,
  });

  FavoriteProductParamsModel copyWith({
    int? page,
    FavoriteProductSort? ordering,
  }) {
    return FavoriteProductParamsModel(
      page: page ?? this.page,
      ordering: ordering ?? this.ordering,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'ordering': ordering,
    };
  }

  factory FavoriteProductParamsModel.fromMap(Map<String, dynamic> map) {
    return FavoriteProductParamsModel(
      page: map['page'],
      ordering: map['ordering'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteProductParamsModel.fromJson(String source) =>
      FavoriteProductParamsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class ReviewParamModel {
  final String productId;
  final int? page;
  String? ordering;
  num? rating;

  ReviewParamModel({
    required this.productId,
    this.page,
    this.ordering,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'ordering': ordering,
      'rating': rating,
      if (page != null) 'page': page,
    };
  }

  factory ReviewParamModel.fromMap(Map<String, dynamic> map) {
    return ReviewParamModel(
      productId: map['productId'] as String,
      ordering: map['ordering'] as String,
      rating: map['rating'] as num,
      page: map['page'] != null ? map['page'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewParamModel.fromJson(String source) =>
      ReviewParamModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

CartParamsModel cartParamsModelFromMap(String str) =>
    CartParamsModel.fromMap(json.decode(str));

String cartParamsModelToMap(CartParamsModel data) => json.encode(data.toMap());

class CartParamsModel {
  final String? cartId;

  CartParamsModel({
    this.cartId,
  });

  factory CartParamsModel.fromMap(Map<String, dynamic> json) => CartParamsModel(
        cartId: json["cart_id"],
      );

  Map<String, dynamic> toMap() => {
        "cart_id": cartId,
      };
}

class GetMyOrderParams {
  final int? page;
  final String orderStatus;

  GetMyOrderParams({required this.page, required this.orderStatus});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'order_status': orderStatus,
    };
  }

  factory GetMyOrderParams.fromMap(Map<String, dynamic> map) {
    return GetMyOrderParams(
      page: map['page'] != null ? map['page'] as int : null,
      orderStatus: map['order_status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetMyOrderParams.fromJson(String source) =>
      GetMyOrderParams.fromMap(json.decode(source) as Map<String, dynamic>);
}
