import 'package:flutter/material.dart';
import 'package:marketplace/providers/auth_provider.dart';
import 'package:marketplace/providers/bottom_nav_provider.dart';
import 'package:marketplace/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  List<DisposableProvider> getDisposableProviders(BuildContext context) {
    return [
      Provider.of<AuthProvider>(context, listen: false),
      Provider.of<BottomNavProvider>(context, listen: false),
      Provider.of<HomeProvider>(context, listen: false),
    ];
  }

  void disposeAllDisposableProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
  }
}

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(
    create: (context) => AuthProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => BottomNavProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => HomeProvider(),
  ),
];

abstract class DisposableProvider with ChangeNotifier {
  void disposeValues();
}
