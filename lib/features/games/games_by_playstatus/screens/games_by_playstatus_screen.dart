import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_by_playstatus/providers/games_by_playstatus_providers.dart';
import 'package:pile_of_shame/features/games/games_by_playstatus/widgets/games_list_screen.dart';
import 'package:pile_of_shame/features/root_page/root_games/widgets/root_games_fab.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/models/play_status.dart';

class GamesByPlaystatusScreen extends ConsumerStatefulWidget {
  GamesByPlaystatusScreen({super.key, required this.playStatuses})
      : assert(playStatuses.isNotEmpty);

  final List<PlayStatus> playStatuses;

  @override
  ConsumerState<GamesByPlaystatusScreen> createState() =>
      _GamesByPlaystatusScreenState();
}

class _GamesByPlaystatusScreenState
    extends ConsumerState<GamesByPlaystatusScreen> {
  late ScrollController _scrollController;
  bool isScrolled = false;

  ImageAssets playStatusToAsset(PlayStatus status) {
    switch (status) {
      case PlayStatus.playing:
      case PlayStatus.replaying:
      case PlayStatus.endlessGame:
        return ImageAssets.controllerUnknown;
      case PlayStatus.onPileOfShame:
        return ImageAssets.gamePile;
      case PlayStatus.onWishList:
        return ImageAssets.list;
      case PlayStatus.cancelled:
        return ImageAssets.deadGame;
      case PlayStatus.completed:
      case PlayStatus.completed100Percent:
        return ImageAssets.barChart;
    }
  }

  void handleScroll() {
    final offset = _scrollController.offset;
    final minScrollExtent = _scrollController.position.minScrollExtent;
    final bool result = offset > minScrollExtent;
    setState(() {
      isScrolled = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final sortedGames =
        ref.watch(gamesByPlayStatusesSortedProvider(widget.playStatuses));
    final sorter =
        ref.watch(gameSortingByPlayStatusProvider(widget.playStatuses.first));

    void onStrategyChanged(GameSorting sorting, SortStrategy value) {
      ref.read(gamesByPlayStatusSorterProvider.notifier).setSorting(
            widget.playStatuses.first,
            sorting.copyWith(sortStrategy: value),
          );
    }

    void onOrderChanged(GameSorting sorting, bool isAscending) {
      ref.read(gamesByPlayStatusSorterProvider.notifier).setSorting(
            widget.playStatuses.first,
            sorting.copyWith(isAscending: isAscending),
          );
    }

    return GamesListScreen(
      sortedGames: sortedGames,
      sorter: sorter,
      onOrderChanged: onOrderChanged,
      onStrategyChanged: onStrategyChanged,
      imageAsset: playStatusToAsset(widget.playStatuses.first),
      title: widget.playStatuses.first.toLocaleString(l10n),
      floatingActionButton: RootGamesFab(
        isExtended: !isScrolled,
        initialPlayStatus: widget.playStatuses.first,
      ),
      scrollController: _scrollController,
    );
  }
}
