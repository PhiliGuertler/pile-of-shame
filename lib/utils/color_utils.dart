import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();

  static Color stringToColor(String input) {
    final stringHash = sha256.convert(utf8.encode(input)).toString();

    final String hueSubstring = stringHash.substring(
      0,
      stringHash.length ~/ 2,
    );
    final String saturationSubstring = stringHash.substring(
      stringHash.length ~/ 2,
      stringHash.length ~/ 4 + stringHash.length ~/ 2,
    );
    final String lightnessSubstring = stringHash.substring(
      stringHash.length ~/ 4 + stringHash.length ~/ 2,
    );
    final double hue = hueSubstring.runes
            .fold(0, (previousValue, element) => previousValue + element)
            .toDouble() *
        10.0 %
        360.0;
    double saturation = saturationSubstring.runes
            .fold(0, (previousValue, element) => previousValue + element)
            .toDouble() *
        0.4 %
        1.0;
    saturation = saturation * 0.5 + 0.5;
    double lightness = lightnessSubstring.runes
            .fold(0, (previousValue, element) => previousValue + element)
            .toDouble() *
        0.1 %
        1.0;
    lightness = lightness * 0.2 + 0.4;

    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }
}
