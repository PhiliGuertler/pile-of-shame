import 'package:flutter/material.dart';

import '../../utils/game_filters.dart';
import '../popup_menu_title.dart';
import '../selected_text_style.dart';

class SortingPopupMenu extends StatelessWidget {
  const SortingPopupMenu({
    super.key,
    required this.filters,
    required this.updateFilters,
  });

  final GameFilters filters;
  final void Function(GameFilters filters) updateFilters;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortStrategy>(
      onSelected: (value) {
        final SortStrategy sortStrategy =
            value == SortStrategy.none ? filters.sortStrategy : value;
        final bool isDescending = value == SortStrategy.none
            ? !filters.isDescending
            : filters.isDescending;
        filters.sortStrategy = sortStrategy;
        filters.isDescending = isDescending;
        updateFilters(filters);
      },
      icon: const Icon(Icons.sort),
      itemBuilder: (context) => [
        const PopupMenuTitle(title: 'Sortieren nach'),
        PopupMenuItem<SortStrategy>(
          value: SortStrategy.byDateOfAddition,
          child: SelectedTextStyle(
            text: 'Hinzufügedatum',
            isSelected: filters.sortStrategy == SortStrategy.byDateOfAddition,
          ),
        ),
        PopupMenuItem<SortStrategy>(
          value: SortStrategy.byAlphabet,
          child: SelectedTextStyle(
            text: 'Alphabet',
            isSelected: filters.sortStrategy == SortStrategy.byAlphabet,
          ),
        ),
        PopupMenuItem<SortStrategy>(
          value: SortStrategy.byAgeRestriction,
          child: SelectedTextStyle(
            text: 'Altersbeschränkung',
            isSelected: filters.sortStrategy == SortStrategy.byAgeRestriction,
          ),
        ),
        PopupMenuItem<SortStrategy>(
          value: SortStrategy.byPrice,
          child: SelectedTextStyle(
            text: 'Preis',
            isSelected: filters.sortStrategy == SortStrategy.byPrice,
          ),
        ),
        PopupMenuItem<SortStrategy>(
          value: SortStrategy.byPlatform,
          child: SelectedTextStyle(
            text: 'Plattform',
            isSelected: filters.sortStrategy == SortStrategy.byPlatform,
          ),
        ),
        PopupMenuItem<SortStrategy>(
          value: SortStrategy.byFavourite,
          child: SelectedTextStyle(
            text: 'Favoriten',
            isSelected: filters.sortStrategy == SortStrategy.byFavourite,
          ),
        ),
        PopupMenuItem<SortStrategy>(
          value: SortStrategy.byStatus,
          child: SelectedTextStyle(
            text: 'Status',
            isSelected: filters.sortStrategy == SortStrategy.byStatus,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuTitle(title: 'Reihenfolge'),
        CheckedPopupMenuItem<SortStrategy>(
          value: SortStrategy.none,
          checked: !filters.isDescending,
          child: const Text('aufsteigend'),
        ),
      ],
    );
  }
}
