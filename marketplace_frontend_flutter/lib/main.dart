import 'package:flutter/material.dart';
import 'package:marketplace/core/constants/constant.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/core/config/theme/theme_manager.dart';
import 'package:marketplace/presentation/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(const MarketPlaceApp());
}

class MarketPlaceApp extends StatelessWidget {
  const MarketPlaceApp({super.key});

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
