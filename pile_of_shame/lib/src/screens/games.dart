import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/persistance/storage.dart';
import 'package:pile_of_shame/src/scrapers/igdb_scraper.dart';
import 'package:pile_of_shame/src/screens/game_addition.dart';
import 'package:pile_of_shame/src/utils/adjustable_scroll_controller.dart';
import 'package:pile_of_shame/src/utils/game_filters.dart';
import 'package:pile_of_shame/src/widgets/game_displays/game_list_item.dart';

import '../models/game.dart';
import '../widgets/filters/filter_popup_menu.dart';
import '../widgets/filters/sorting_popup_menu.dart';
import '../widgets/game_list_summary.dart';
import '../widgets/scraping_progress_view.dart';
import 'game_details.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  List<Game> _games = [];

  GameFilters _filters = GameFilters();

  bool isSearchActive = false;

  Stream<int>? _scrapingProgress;
  final AdjustableScrollController _scrollController =
      AdjustableScrollController();
  late final AnimationController _scrollDownAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<Offset> _scrollDownAnimation = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _scrollDownAnimationController,
      curve: Curves.linearToEaseOut,
    ),
  );
  late final AnimationController _scrollUpAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<Offset> _scrollUpAnimation = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _scrollUpAnimationController,
      curve: Curves.linearToEaseOut,
    ),
  );

  void refresh() {
    Storage().readGames().then((value) {
      List<Game> filteredGames = _filters.filter(value);
      setState(() {
        _games = filteredGames;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();

    _scrollController.addListener(() {
      final double topThreshold =
          _scrollController.position.minScrollExtent + 40.0;
      final double bottomThreshold =
          _scrollController.position.maxScrollExtent - 40.0;
      if (_scrollController.offset > topThreshold) {
        _scrollUpAnimationController.forward();
      } else if (_scrollController.offset < topThreshold) {
        _scrollUpAnimationController.reverse();
      }
      if (_scrollController.offset > bottomThreshold) {
        _scrollDownAnimationController.reverse();
      } else if (_scrollController.offset < bottomThreshold) {
        _scrollDownAnimationController.forward();
      }
    });
    _scrollDownAnimationController.value =
        _scrollDownAnimationController.upperBound;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Alle Spiele'),
              bottom: PreferredSize(
                preferredSize:
                    Size.fromHeight(6.0 + (isSearchActive ? 40.0 : 0.0)),
                child: Column(
                  children: [
                    if (isSearchActive)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search),
                            hintText: 'Nach Spielen suchen',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _filters.searchQuery = value;
                            });
                            refresh();
                          },
                        ),
                      ),
                    StreamBuilder<int>(
                      stream: _scrapingProgress,
                      initialData: -1,
                      builder: (context, snapshot) =>
                          snapshot.hasData && snapshot.data != -1
                              ? const LinearProgressIndicator()
                              : Container(),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      debugPrint('searching!');
                      setState(() {
                        isSearchActive = !isSearchActive;
                      });
                    },
                    icon:
                        Icon(isSearchActive ? Icons.search_off : Icons.search)),
                FilterPopupMenu(
                    filters: _filters,
                    updateFilters: ((filters) {
                      setState(() {
                        _filters = filters;
                      });
                      refresh();
                    })),
                SortingPopupMenu(
                  filters: _filters,
                  updateFilters: (filters) {
                    setState(() {
                      _filters = filters;
                    });
                    refresh();
                  },
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        refresh();
                      },
                      value: 0,
                      child: const ListTile(
                        leading: Icon(Icons.storage),
                        title: Text('Neu laden'),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () async {
                        final scraper = IGDBScraper();
                        setState(() {
                          _scrapingProgress = scraper
                              .scrapeGameList(_games)
                              .asBroadcastStream();
                          _scrapingProgress!.listen((event) {
                            if (event == _games.length) {
                              // update the list and reset the stream
                              refresh();
                              _scrapingProgress =
                                  Stream.value(-1).asBroadcastStream();
                            }
                          });
                        });
                      },
                      value: 1,
                      child: const ListTile(
                        leading: Icon(Icons.refresh),
                        title: Text('Infos von IGDB laden'),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () async {
                        final scraper = IGDBScraper();
                        setState(() {
                          _scrapingProgress = scraper
                              .scrapeGameList(_games,
                                  skipIfAlreadyScraped: false)
                              .asBroadcastStream();
                          _scrapingProgress!.listen((event) {
                            if (event == _games.length) {
                              // update the list and reset the stream
                              refresh();
                              _scrapingProgress =
                                  Stream.value(-1).asBroadcastStream();
                            }
                          });
                        });
                      },
                      value: 2,
                      child: const ListTile(
                        leading: Icon(Icons.update),
                        title: Text('IGDB Update erzwingen'),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        Future.delayed(
                          const Duration(seconds: 0),
                          () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                  'Willst du wirklich ALLE Scraping-Infos löschen?'),
                              content: const Text(
                                  'Sie können nur durch den Import einer Datei wieder hergestellt werden.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'Cancel');
                                  },
                                  child: const Text('Abbrechen'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    for (var element in _games) {
                                      element.coverImage = null;
                                      element.externalGameId = null;
                                      element.backgroundImage = null;
                                      element.onlineScore = null;
                                      element.releaseDate = null;
                                    }
                                    await Storage().writeGames(_games);
                                    refresh();
                                    if (!mounted) return;
                                    Navigator.pop(context, 'Delete');
                                  },
                                  child: const Text('Löschen'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      // value: 3,
                      child: const ListTile(
                        leading: Icon(Icons.restore),
                        title: Text('Scraping-Info entfernen'),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () async {
                        final bool wasSuccessful =
                            await Storage().exportGames();
                        if (wasSuccessful) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Spiele erfolgreich exportiert'),
                            ),
                          );
                        }
                      },
                      value: 10,
                      child: const ListTile(
                        leading: Icon(Icons.save),
                        title: Text('Spiele exportieren'),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () async {
                        List<Game> allGames = await Storage().importGames();
                        await Storage().writeGames(allGames);
                        refresh();
                      },
                      value: 11,
                      child: const ListTile(
                        leading: Icon(Icons.file_open),
                        title: Text('Spiele importieren'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: _games.length + 2,
              itemBuilder: (context, index) {
                if (index < _games.length) {
                  final game = _games[index];
                  return InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameDetails(
                                    originalGame: game,
                                  )));
                      refresh();
                    },
                    child: GameListItem(
                      game: game,
                    ),
                  );
                } else if (index == _games.length) {
                  return Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: const Divider(
                      thickness: 3,
                    ),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.only(
                        right: 8.0, left: 8.0, top: 16.0, bottom: 100.0),
                    child: GameListSummary(games: _games),
                  );
                }
              },
            ),
          ),
          StreamBuilder<int>(
            stream: _scrapingProgress,
            initialData: -1,
            builder: (context, snapshot) => Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: snapshot.hasData &&
                      snapshot.data! > -1 &&
                      snapshot.data! < _games.length
                  ? ScrapingProgressView(
                      currentItem: snapshot.data!,
                      totalItems: _games.length,
                      currentItemName:
                          snapshot.data! > -1 && snapshot.data! < _games.length
                              ? _games[snapshot.data!].title
                              : "Momentchen!",
                    )
                  : Container(),
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 25.0 * 2 + 8.0 * 2 + 25.0 * 2 + 8.0 * 2,
            child: SlideTransition(
              position: _scrollUpAnimation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    color: Colors.black,
                    onPressed: () {
                      _scrollController.animateTo(
                          _scrollController.position.minScrollExtent,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut);
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 25.0 * 2 + 8.0 * 2,
            child: SlideTransition(
              position: _scrollDownAnimation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    color: Colors.black,
                    onPressed: () {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut);
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.black,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddGameScreen(),
                      ),
                    );
                    refresh();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
