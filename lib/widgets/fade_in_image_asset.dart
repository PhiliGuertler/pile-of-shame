import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:transparent_image/transparent_image.dart';

class FadeInImageAsset extends StatelessWidget {
  final ImageAssets asset;
  final BoxFit fit;
  final Duration animationDuration;
  final double? width;
  final double? height;

  const FadeInImageAsset({
    super.key,
    required this.asset,
    this.fit = BoxFit.cover,
    this.animationDuration = const Duration(milliseconds: 250),
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      fadeInDuration: animationDuration,
      fadeOutDuration: animationDuration,
      width: width,
      height: height,
      fit: fit,
      placeholder: MemoryImage(kTransparentImage),
      image: AssetImage(asset.value),
      fadeInCurve: Curves.easeInOut,
    );
  }
}
