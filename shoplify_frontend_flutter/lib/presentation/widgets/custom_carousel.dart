import 'package:flutter/material.dart';

class CustomCarousel extends StatelessWidget {
  const CustomCarousel({super.key, required this.children, this.maxHeight});
  final List<Widget> children;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight ?? 200),
      child: CarouselView(
        scrollDirection: Axis.horizontal,
        itemExtent: 200,
        padding: const EdgeInsets.all(10.0),
        children: children,
      ),
    );
  }
}
