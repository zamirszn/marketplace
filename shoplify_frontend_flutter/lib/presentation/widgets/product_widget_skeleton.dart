import 'package:flutter/material.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductWidgetSkeleton extends StatelessWidget {
  const ProductWidgetSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(AppSize.s10),
        child: Container(
          color: Colors.white,
          height: 400,
          width: 400,
        ),
      ),
    );
  }
}
