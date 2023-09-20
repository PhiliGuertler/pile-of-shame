import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/game_platform_input_field.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:pile_of_shame/utils/validators.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/input/dropdown_search_field.dart';

class PlatformDropdown extends ConsumerWidget {
  final GamePlatform? value;
  final void Function(GamePlatform value) onChanged;

  const PlatformDropdown({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamePlatforms = ref.watch(activeGamePlatformsProvider);
    final allPlatforms = gamePlatforms.maybeWhen(
      data: (data) => data,
      orElse: () => GamePlatform.values,
    );

    final List<GamePlatform> sortedGamePlatforms = List.from(allPlatforms);
    sortedGamePlatforms.sort(
      (a, b) => a
          .localizedName(AppLocalizations.of(context)!)
          .toLowerCase()
          .compareTo(
            b.localizedName(AppLocalizations.of(context)!).toLowerCase(),
          ),
    );

    return DropdownSearchField<GamePlatform>(
      key: const ValueKey("game_platform_dropdown"),
      value: value,
      filter: (searchTerm, option) {
        // check if the platform family is matching
        final matchesFamily =
            option.family.name.toLowerCase().contains(searchTerm);

        // check if the platform's abbreviation contains all the search terms
        final matchesAbbreviation =
            option.abbreviation.toLowerCase().contains(searchTerm);
        // check if the platform's name conains all the search terms
        final matchesName = option
            .localizedName(AppLocalizations.of(context)!)
            .toLowerCase()
            .contains(searchTerm);

        return matchesFamily || matchesAbbreviation || matchesName;
      },
      optionBuilder: (context, option, onTap) => ListTile(
        key: ValueKey(option.abbreviation),
        leading: GamePlatformIcon(platform: option),
        title: Text(option.localizedName(AppLocalizations.of(context)!)),
        onTap: onTap,
      ),
      valueBuilder: (context, option, onTap) => GamePlatformInputField(
        key: const ValueKey("game_platform_input"),
        value: option,
        label: Text("${AppLocalizations.of(context)!.platform}*"),
        onTap: onTap,
        validator: Validators.validateFieldIsRequired(context),
      ),
      options: sortedGamePlatforms,
      onChanged: onChanged,
    );
  }
}
