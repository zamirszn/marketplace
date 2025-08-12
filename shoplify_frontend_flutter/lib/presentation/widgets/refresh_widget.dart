import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';

class RefreshWidget extends StatelessWidget {
  const RefreshWidget(
      {super.key, required this.onRefresh, required this.child});
  final VoidCallback onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
        onRefresh: () async => onRefresh(),
        indicatorBuilder: (_, __) {
          return Transform.scale(scale: 1.1, child: const LoadingWidget());
        },
        child: child);
  }
}
