import 'package:flutter/material.dart';
import 'package:shoplify/presentation/widgets/loading/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator.contained(
      
    );
  }
}
