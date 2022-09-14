import 'package:flutter/material.dart';

import 'autocomplete_search_options_view.dart';

class GamePlatformAutocomplete extends StatelessWidget {
  const GamePlatformAutocomplete(
      {super.key,
      this.onSelected,
      required this.platforms,
      this.validator,
      this.value,
      this.title = 'Platform*'});

  final void Function(String)? onSelected;
  final String? Function(String?)? validator;
  final String? value;
  final Iterable<String> platforms;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
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
          ),
          onChanged: onSelected,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          validator: validator,
        );
      }),
      optionsBuilder: ((textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return platforms.where((platform) {
          return platform
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      }),
      optionsViewBuilder: (context, onSelected, options) {
        return AutocompleteSearchOptionsView(
          onSelected: onSelected,
          options: options,
          searchTerm: value ?? '',
          maxOptionsHeight: 400,
        );
      },
    );
  }
}
