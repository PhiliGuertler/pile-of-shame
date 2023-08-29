import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

class GamePlatformInputField extends StatelessWidget {
  final Widget label;
  final GamePlatform? value;
  final VoidCallback onTap;

  const GamePlatformInputField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        label: label,
        suffixIcon: const Icon(Icons.expand_more),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ImageContainer(
            child: value != null
                ? Image.asset(value!.iconPath)
                : Icon(
                    Icons.sports_esports,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
          ),
        ),
      ),
      controller:
          value != null ? TextEditingController(text: value!.name) : null,
      onTap: onTap,
    );
  }
}
