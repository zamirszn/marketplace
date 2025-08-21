import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/bloc_providers.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/config/theme/theme_manager.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
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
    return MultiBlocProvider(
      providers: blocProviders,
      child: DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme =
            lightDynamic ?? ColorScheme.fromSeed(seedColor: ColorManager.blue);

        ColorScheme darkColorScheme = darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: ColorManager.blue,
              brightness: Brightness.dark,
            );

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerDelegate: appRouter.routerDelegate,
          routeInformationProvider: appRouter.routeInformationProvider,
          routeInformationParser: appRouter.routeInformationParser,
          theme: AppTheme.getTheme(lightColorScheme),
          themeMode: ThemeMode.system,
          darkTheme: AppTheme.getTheme(darkColorScheme),
          title: Constant.appName,
        );
      }),
    );
  }
}
