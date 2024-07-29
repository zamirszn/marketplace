import 'package:flutter/material.dart';
import 'package:marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  List<DisposableProvider> getDisposableProviders(BuildContext context) {
    return [
      Provider.of<AuthProvider>(context, listen: false),
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
];

abstract class DisposableProvider with ChangeNotifier {
  void disposeValues();
}
