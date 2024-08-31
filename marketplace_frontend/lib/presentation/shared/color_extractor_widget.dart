import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/presentation/resources/color_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';

class ColorExtractorWidget extends StatefulWidget {
  const ColorExtractorWidget({
    super.key,
    required this.imageString,
    required this.shouldExtractColor,
  });
  final String imageString;
  final bool shouldExtractColor;

  @override
  ColorExtractorWidgetState createState() => ColorExtractorWidgetState();
}

class ColorExtractorWidgetState extends State<ColorExtractorWidget> {
  List<Color> colors = [];
  int colorsCountToExtract = 2;
  Uint8List? imageBytes;

  @override
  void initState() {
    if (widget.shouldExtractColor == true) {
      extractColors();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.s10),
      child: ColoredBox(
        color: colors.isEmpty ? ColorManager.color6 : colors.last,
        child: Center(child: Image.asset(widget.imageString)),
      ),
    );
  }

  Future<Uint8List> getImageBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);

    final Uint8List bytes = data.buffer.asUint8List();

    return bytes;
  }

  void extractColors() async {
    imageBytes = await getImageBytes(widget.imageString);

    try {
      DominantColors extractor = DominantColors(
          bytes: imageBytes!, dominantColorsCount: colorsCountToExtract);

      List<Color> dominantColors = extractor.extractDominantColors();

      colors = dominantColors;

      setState(() {});
    } catch (e) {
      colors.clear();
    }
  }
}
