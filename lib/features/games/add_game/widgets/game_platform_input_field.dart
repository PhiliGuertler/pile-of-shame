import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

class GamePlatformInputField extends StatelessWidget {
  final Widget label;
  final GamePlatform? value;
  final VoidCallback onTap;
  final String? Function(String? value)? validator;

  const GamePlatformInputField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        label: label,
        suffixIcon: const Icon(Icons.expand_more),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: value != null
              ? GamePlatformIcon(
                  platform: value!,
                )
              : ImageContainer(
                  child: Icon(
                    Icons.sports_esports,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
        ),
      ),
      validator: validator,
      controller: value != null
          ? TextEditingController(
              text: value!.localizedName(AppLocalizations.of(context)!))
          : null,
      onTap: onTap,
    );
  }
}
