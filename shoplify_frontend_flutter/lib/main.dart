import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shoplify/presentation/pages/search/bloc/search_bloc.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/core/config/theme/theme_manager.dart';
import 'package:shoplify/presentation/service_locator.dart';
import 'package:shoplify/presentation/pages/auth/account_verification/bloc/account_verification_bloc.dart';
import 'package:shoplify/presentation/pages/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:shoplify/presentation/pages/auth/login/bloc/login_bloc.dart';
import 'package:shoplify/presentation/pages/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/pages/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/pages/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/pages/home/filter_bottom_sheet/bloc/filter_bottomsheet_bloc.dart';
import 'package:shoplify/presentation/widgets/add_to_cart_bottomsheet/bloc/add_to_cart_bottomsheet_bloc.dart';
import 'package:shoplify/presentation/widgets/count_down_widget/bloc/countdown_bloc.dart';
import 'package:shoplify/presentation/widgets/product_category/bloc/product_category_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  runApp(const MarketPlaceApp());
}

class MarketPlaceApp extends StatefulWidget {
  const MarketPlaceApp({super.key});

  @override
  State<MarketPlaceApp> createState() => _MarketPlaceAppState();
}

class _MarketPlaceAppState extends State<MarketPlaceApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.routerDelegate,
        routeInformationProvider: appRouter.routeInformationProvider,
        routeInformationParser: appRouter.routeInformationParser,
        theme: AppTheme.appTheme,
        title: Constant.appName,
      ),
    );
  }
}

final List<SingleChildWidget> providers = [
  BlocProvider(create: (context) => FavoriteBloc()),
  BlocProvider(
    create: (context) => CartBloc(),
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
