import 'package:flutter/material.dart';

import '../../utils/game_filters.dart';
import '../popup_menu/popup_menu_title.dart';
import '../popup_menu/stateful_popup_menu_item.dart';
import '../popup_menu/stateful_popup_menu_item_controller.dart';

class SortingPopupMenu extends StatefulWidget {
  const SortingPopupMenu({
    super.key,
    required this.filters,
    required this.updateFilters,
  });

  final GameFilters filters;
  final void Function(GameFilters filters) updateFilters;

  @override
  State<SortingPopupMenu> createState() => _SortingPopupMenuState();
}

class _SortingPopupMenuState extends State<SortingPopupMenu> {
  GameFilters _filters = GameFilters();

  final StatefulPopupMenuItemController<GameFilters>
      _statefulPopupMenuItemController =
      StatefulPopupMenuItemController<GameFilters>();

  @override
  void initState() {
    super.initState();
    _filters = widget.filters;
  }

  void onSelected(SortStrategy value) {
    final SortStrategy sortStrategy =
        value == SortStrategy.none ? _filters.sortStrategy : value;
    final bool isDescending = value == SortStrategy.none
        ? !_filters.isDescending
        : _filters.isDescending;
    setState(() {
      _filters.sortStrategy = sortStrategy;
      _filters.isDescending = isDescending;
    });
    _statefulPopupMenuItemController.notifyAll(_filters);
    widget.updateFilters(_filters);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<GameFilters>(
      icon: const Icon(Icons.sort),
      itemBuilder: (context) => [
        const PopupMenuTitle(title: 'Sortieren nach'),
        StatefulPopupMenuItem<GameFilters>(
          onTap: () {
            onSelected(SortStrategy.byDateOfAddition);
          },
          onStateChanged: (filters) {
            return StatefulPopupMenuItemProps(
              title: 'Hinzufügedatum',
              isSelected: filters.sortStrategy == SortStrategy.byDateOfAddition,
            );
          },
          value: _filters,
          controller: _statefulPopupMenuItemController,
        ),
        StatefulPopupMenuItem<GameFilters>(
          onTap: () {
            onSelected(SortStrategy.byAlphabet);
          },
          onStateChanged: (filters) {
            return StatefulPopupMenuItemProps(
              title: 'Alphabet',
              isSelected: filters.sortStrategy == SortStrategy.byAlphabet,
            );
          },
          value: _filters,
          controller: _statefulPopupMenuItemController,
        ),
        StatefulPopupMenuItem<GameFilters>(
          onTap: () {
            onSelected(SortStrategy.byAgeRestriction);
          },
          onStateChanged: (filters) {
            return StatefulPopupMenuItemProps(
              title: 'Altersbeschränkung',
              isSelected: filters.sortStrategy == SortStrategy.byAgeRestriction,
            );
          },
          value: _filters,
          controller: _statefulPopupMenuItemController,
        ),
        StatefulPopupMenuItem<GameFilters>(
          onTap: () {
            onSelected(SortStrategy.byPrice);
          },
          onStateChanged: (filters) {
            return StatefulPopupMenuItemProps(
              title: 'Preis',
              isSelected: filters.sortStrategy == SortStrategy.byPrice,
            );
          },
          value: _filters,
          controller: _statefulPopupMenuItemController,
        ),
        StatefulPopupMenuItem<GameFilters>(
          onTap: () {
            onSelected(SortStrategy.byPlatform);
          },
          onStateChanged: (filters) {
            return StatefulPopupMenuItemProps(
              title: 'Plattform',
              isSelected: filters.sortStrategy == SortStrategy.byPlatform,
            );
          },
          value: _filters,
          controller: _statefulPopupMenuItemController,
        ),
        StatefulPopupMenuItem<GameFilters>(
          onTap: () {
            onSelected(SortStrategy.byFavourite);
          },
          onStateChanged: (filters) {
            return StatefulPopupMenuItemProps(
              title: 'Favoriten',
              isSelected: filters.sortStrategy == SortStrategy.byFavourite,
            );
          },
          value: _filters,
          controller: _statefulPopupMenuItemController,
        ),
        StatefulPopupMenuItem<GameFilters>(
          onTap: () {
            onSelected(SortStrategy.byStatus);
          },
          onStateChanged: (filters) {
            return StatefulPopupMenuItemProps(
              title: 'Status',
              isSelected: filters.sortStrategy == SortStrategy.byStatus,
            );
          },
          value: _filters,
          controller: _statefulPopupMenuItemController,
        ),
        const PopupMenuDivider(),
        const PopupMenuTitle(title: 'Reihenfolge'),
        StatefulPopupMenuItem<GameFilters>(
          value: _filters,
          onStateChanged: (filters) {
            return StatefulPopupMenuItemProps(
              title: filters.isDescending ? 'absteigend' : 'aufsteigend',
              leading: filters.isDescending
                  ? const Icon(Icons.south)
                  : const Icon(Icons.north),
            );
          },
          onTap: () {
            onSelected(SortStrategy.none);
          },
          controller: _statefulPopupMenuItemController,
        ),
      ],
    );
  }
}
