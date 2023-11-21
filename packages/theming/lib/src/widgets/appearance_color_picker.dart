import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theming/theming.dart';

class AppearanceColorPicker extends ConsumerWidget {
  final List<Color> additionalColors;

  const AppearanceColorPicker({
    super.key,
    this.additionalColors = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsProvider);

    return BlockPicker(
      availableColors: [
        ...additionalColors,
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.lime,
        Colors.lightGreen,
        Colors.green,
        Colors.teal,
        Colors.cyan,
        Colors.lightBlue,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
        Colors.pink,
        Colors.brown,
      ],
      pickerColor: themeSettings.maybeWhen(
        data: (themeSettings) => themeSettings.primaryColor,
        orElse: () => Colors.orange,
      ),
      onColorChanged: (value) {
        ref.read(themeSettingsProvider.notifier).setPrimaryColor(value);
      },
    );
  }
}
