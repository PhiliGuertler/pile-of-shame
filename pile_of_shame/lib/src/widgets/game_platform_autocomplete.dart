import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/game_platform.dart';

import 'autocomplete_search_options_view.dart';

typedef GamePlatformType = GamePlatform;

class GamePlatformAutocomplete extends StatelessWidget {
  const GamePlatformAutocomplete(
      {super.key,
      required this.textEditingController,
      required this.focusNode,
      this.value,
      this.onSelected,
      required this.onRemove,
      this.isRemovable = false,
      required this.platforms,
      this.validator,
      this.title = 'Plattform*'});

  final void Function(GamePlatformType)? onSelected;
  final void Function() onRemove;
  final GamePlatformType? value;
  final bool isRemovable;
  final String? Function(String?)? validator;
  final Iterable<GamePlatformType> platforms;
  final String title;

  final TextEditingController textEditingController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<GamePlatformType>(
      focusNode: focusNode,
      onSelected: onSelected,
      textEditingController: textEditingController,
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
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: InkWell(
                      child: const Icon(Icons.close, size: 15),
                      onTap: () {
                        onRemove();
                      },
                    ),
                  )
                : null),
          ),
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
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
          searchTerm: textEditingController.text,
          maxOptionsHeight: 400,
        );
      },
    );
  }
}
