import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_by_playstatus/providers/games_by_playstatus_providers.dart';
import 'package:pile_of_shame/features/games/games_by_playstatus/widgets/games_list_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/game_sorting.dart';

class FavoriteGamesScreen extends ConsumerWidget {
  const FavoriteGamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final sortedGames = ref.watch(favoriteGamesSortedProvider);
    final sorter = ref.watch(favoriteGamesSorterProvider);

    void onStrategyChanged(GameSorting sorting, SortStrategy value) {
      ref.read(favoriteGamesSorterProvider.notifier).setSorting(
            sorting.copyWith(sortStrategy: value),
          );
    }

    void onOrderChanged(GameSorting sorting, bool isAscending) {
      ref.read(favoriteGamesSorterProvider.notifier).setSorting(
            sorting.copyWith(isAscending: isAscending),
          );
    }

    return GamesListScreen(
      sortedGames: sortedGames,
      sorter: sorter,
      onOrderChanged: onOrderChanged,
      onStrategyChanged: onStrategyChanged,
      title: l10n.favorites,
      imageAsset: ImageAssets.favorite,
    );
  }
}
