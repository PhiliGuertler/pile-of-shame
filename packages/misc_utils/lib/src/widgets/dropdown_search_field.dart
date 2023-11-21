import 'package:flutter/material.dart';

class DropdownSearchField<T> extends StatefulWidget {
  final void Function(T value) onChanged;
  final Widget? prefix;
  final List<T> options;
  final bool Function(String searchTerm, T option) filter;
  final Widget Function(BuildContext context, T option, VoidCallback onTap)
      optionBuilder;
  final Widget Function(BuildContext context, T? option, VoidCallback onTap)
      valueBuilder;
  final T? value;

  const DropdownSearchField({
    super.key,
    required this.onChanged,
    required this.options,
    required this.filter,
    required this.optionBuilder,
    required this.valueBuilder,
    this.value,
    this.prefix,
  });

  @override
  State<DropdownSearchField<T>> createState() => _CategorySearchFieldState<T>();
}

class _CategorySearchFieldState<T> extends State<DropdownSearchField<T>> {
  late SearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<T> filterOptions(String searchTerm) {
    final searchTokens =
        searchTerm.split(" ").where((element) => element.isNotEmpty);

    return widget.options
        .where(
          (element) =>
              searchTokens.every((token) => widget.filter(token, element)),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      builder: (context, controller) {
        return widget.valueBuilder(context, widget.value, () {
          controller.openView();
        });
      },
      suggestionsBuilder: (context, controller) {
        final filteredOptions = filterOptions(controller.text);
        final result = filteredOptions
            .map(
              (option) => widget.optionBuilder(context, option, () {
                controller.closeView(controller.text);
                widget.onChanged(option);
              }),
            )
            .toList();

        if (result.isNotEmpty) {
          result.last = Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: result.last,
          );
        }

        return result;
      },
    );
  }
}
