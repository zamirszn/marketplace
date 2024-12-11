import 'package:flutter/material.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/core/config/theme/theme_manager.dart';
import 'package:shoplify/presentation/service_locator.dart';

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.routerDelegate,
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      theme: AppTheme.appTheme,
      title: Constant.appName,
    );
  }
}
