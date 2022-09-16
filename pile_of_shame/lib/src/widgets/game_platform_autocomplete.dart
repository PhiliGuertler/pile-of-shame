import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/game_platform.dart';

import 'autocomplete_search_options_view.dart';

typedef GamePlatformType = GamePlatform;

class GamePlatformAutocomplete extends StatelessWidget {
  const GamePlatformAutocomplete(
      {super.key,
      required this.onChanged,
      required this.value,
      this.onSelected,
      required this.onRemove,
      this.isRemovable = false,
      required this.platforms,
      this.validator,
      this.title = 'Platform*'});

  final void Function(GamePlatformType)? onSelected;
  final void Function() onRemove;
  final void Function(String) onChanged;
  final String value;
  final bool isRemovable;
  final String? Function(String?)? validator;
  final Iterable<GamePlatformType> platforms;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<GamePlatformType>(
      onSelected: onSelected,
      fieldViewBuilder:
          ((context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.videogame_asset),
            hintText: 'Wii, Nintendo Switch, PC, ...',
            labelText: title,
            suffix: (isRemovable
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      onRemove();
                    },
                  )
                : null),
          ),
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          onChanged: (String value) {
            onChanged(value);
            if (value.isEmpty && isRemovable) {
              // notify the UI that the current input is now empty
              onRemove();
            }
          },
          validator: validator,
        );
      }),
      optionsBuilder: ((textEditingValue) {
        return platforms.where((platform) {
          return platform.name
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()) ||
              platform.abbreviation
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
        });
      }),
      optionsViewBuilder: (context, onSelected, options) {
        return AutocompleteSearchOptionsView<GamePlatformType>(
          onSelected: onSelected,
          options: options,
          searchTerm: value,
          maxOptionsHeight: 400,
        );
      },
    );
  }
}
