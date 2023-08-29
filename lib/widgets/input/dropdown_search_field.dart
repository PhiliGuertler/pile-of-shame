import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownSearchField<T> extends ConsumerStatefulWidget {
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
  ConsumerState<DropdownSearchField<T>> createState() =>
      _CategorySearchFieldState<T>();
}

class _CategorySearchFieldState<T>
    extends ConsumerState<DropdownSearchField<T>> {
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
        .where((element) =>
            searchTokens.every((token) => widget.filter(token, element)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      isFullScreen: false,
      searchController: _searchController,
      builder: (context, controller) {
        return widget.valueBuilder(context, widget.value, () {
          controller.openView();
        });
      },
      suggestionsBuilder: (context, controller) {
        final filteredOptions = filterOptions(controller.text);
        return filteredOptions.map(
          (option) => widget.optionBuilder(context, option, () {
            controller.closeView(controller.text);
            widget.onChanged(option);
          }),
        );
      },
    );
  }
}
