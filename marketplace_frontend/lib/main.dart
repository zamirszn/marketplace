import 'package:flutter/material.dart';
import 'package:marketplace/app/constant.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/theme_manager.dart';
import 'package:marketplace/providers/base_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MarketPlaceApp());
}

class MarketPlaceApp extends StatelessWidget {
  const MarketPlaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.routerDelegate,
        routeInformationProvider: appRouter.routeInformationProvider,
        routeInformationParser: appRouter.routeInformationParser,
        theme: appTheme,
        title: Constant.appName,
      ),
    );
  }
}
