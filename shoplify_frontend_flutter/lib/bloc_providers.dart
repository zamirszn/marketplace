import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shoplify/presentation/all_products/bloc/all_products_bloc.dart';
import 'package:shoplify/presentation/pages/auth/account_verification/bloc/account_verification_bloc.dart';
import 'package:shoplify/presentation/pages/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:shoplify/presentation/pages/auth/login/bloc/login_bloc.dart';
import 'package:shoplify/presentation/pages/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/pages/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/pages/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/pages/home/filter_bottom_sheet/bloc/filter_bottomsheet_bloc.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/pages/order/bloc/order_bloc.dart';
import 'package:shoplify/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:shoplify/presentation/pages/review/bloc/review_bloc.dart';
import 'package:shoplify/presentation/pages/search/bloc/search_bloc.dart';
import 'package:shoplify/presentation/widgets/add_to_cart_bottomsheet/bloc/add_to_cart_bottomsheet_bloc.dart';
import 'package:shoplify/presentation/widgets/count_down_widget/bloc/countdown_bloc.dart';
import 'package:shoplify/presentation/widgets/new_product_widget/bloc/new_product_bloc.dart';
import 'package:shoplify/presentation/widgets/popular_product_widget/bloc/popular_product_bloc.dart';
import 'package:shoplify/presentation/widgets/product_category/bloc/product_category_bloc.dart';

final List<SingleChildWidget> blocProviders = [
  BlocProvider(create: (context) => FavoriteBloc()),
  BlocProvider(create: (context) => ReviewBloc()),
  BlocProvider(create: (context) => ProfileBloc()),
  BlocProvider(create: (context) => PopularProductBloc()),
  BlocProvider(create: (context) => NewProductBloc()),
  BlocProvider(
    create: (context) => CartBloc(),
  ),
  BlocProvider(
    create: (context) => AllProductsBloc(),
  ),
  BlocProvider(
    create: (context) => OrderBloc(),
  ),
  BlocProvider<BottomNavBloc>(
    create: (context) => BottomNavBloc(),
  ),
  BlocProvider<ProductBloc>(
    create: (context) => ProductBloc(),
  ),
  BlocProvider<CountdownBloc>(
    create: (context) => CountdownBloc(),
  ),
  BlocProvider<AccountVerificationBloc>(
    create: (context) => AccountVerificationBloc(),
  ),
  BlocProvider<LoginBloc>(
    create: (context) => LoginBloc(),
  ),
  BlocProvider<ForgotPasswordBloc>(
    create: (context) => ForgotPasswordBloc(),
  ),
  BlocProvider<AddToCartBottomsheetBloc>(
    create: (context) => AddToCartBottomsheetBloc(),
  ),
  BlocProvider<ProductDetailsBloc>(
    create: (context) => ProductDetailsBloc(),
  ),
  BlocProvider<SearchBloc>(
    create: (context) => SearchBloc(),
  ),
  BlocProvider<ProductCategoryBloc>(create: (context) => ProductCategoryBloc()),
  BlocProvider<FilterBottomsheetBloc>(
      create: (context) => FilterBottomsheetBloc()),
];
