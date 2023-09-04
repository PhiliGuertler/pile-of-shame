import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class SliverFilters<T> extends StatelessWidget {
  final String title;
  final List<T> selectedValues;
  final List<T> options;
  final void Function(bool isSelected) onSelectAll;
  final Widget Function(T option, List<T> Function(bool? isSelected) onChanged)
      optionBuilder;

  const SliverFilters({
    super.key,
    required this.title,
    required this.selectedValues,
    required this.options,
    required this.onSelectAll,
    required this.optionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Container(
        color: Theme.of(context).colorScheme.surface,
        child: CheckboxListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          value: selectedValues.length == options.length,
          onChanged: (value) {
            if (value != null) {
              onSelectAll(value);
            }
          },
        ),
      ),
      sliver: SliverList.list(
        children: [
          ...options.map(
            (option) => optionBuilder(
              option,
              (value) {
                List<T> filters = List.from(selectedValues);
                if (value != null) {
                  if (value) {
                    filters.add(option);
                  } else {
                    filters.remove(option);
                  }
                }
                return filters;
              },
            ),
          ),
        ],
      ),
    );
  }
}
