import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/src/persistance/storage.dart';

import '../models/age_restrictions.dart';
import '../models/game.dart';
import '../models/game_platform.dart';
import '../models/game_status.dart';
import '../widgets/age_restriction.dart';
import '../widgets/game_platform_autocomplete.dart';
import 'game_addition.dart';

class EditGameDetails extends StatefulWidget {
  const EditGameDetails({super.key, required this.game});

  final Game game;

  @override
  State<EditGameDetails> createState() => _EditGameDetailsState();
}

class _EditGameDetailsState extends State<EditGameDetails> {
  List<PlatformSearchInput> _selectedPlatforms = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _releaseDate;
  final TextEditingController _releaseDateController = TextEditingController();
  final TextEditingController _metacriticScoreController =
      TextEditingController();
  final TextEditingController _backgroundImageController =
      TextEditingController();
  final TextEditingController _rawgGameIdController = TextEditingController();
  AgeRestriction? _ageRestrictionController;
  GameState? _selectedGameState;

  @override
  void initState() {
    super.initState();
    // initialize platforms
    final List<PlatformSearchInput> initialPlatforms =
        widget.game.platforms.map((platform) {
      final GamePlatform gamePlatform = GamePlatforms.byName(platform);
      final input = PlatformSearchInput(platform: gamePlatform);
      input.textEditingController.text =
          '${gamePlatform.name} [${gamePlatform.abbreviation}]';
      return input;
    }).toList();
    initialPlatforms.add(PlatformSearchInput());
    setState(() {
      _selectedPlatforms = initialPlatforms;
    });

    // initialize other controllers
    setState(() {
      _nameController.text = widget.game.title;
      _priceController.text = widget.game.price?.toStringAsFixed(2) ?? '';
      _notesController.text = widget.game.notes ?? '';
      _releaseDate = widget.game.releaseDate;
      _releaseDateController.text =
          _releaseDate != null ? DateFormat.yMd().format(_releaseDate!) : '';
      _metacriticScoreController.text =
          widget.game.metacriticScore?.toString() ?? '';
      _backgroundImageController.text = widget.game.backgroundImage ?? '';
      _rawgGameIdController.text = widget.game.rawgGameId?.toString() ?? '';
      _ageRestrictionController = widget.game.ageRestriction;
      _selectedGameState = widget.game.gameState;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> platformInputs = _selectedPlatforms.asMap().entries.map(
      (platformInput) {
        return GamePlatformAutocomplete(
          title:
              'Plattform${platformInput.key == 0 ? '*' : ' ${(platformInput.key + 1).toString()}'}',
          textEditingController: platformInput.value.textEditingController,
          value: platformInput.value.platform,
          platforms: GamePlatforms.toList().where((element) {
            return !_selectedPlatforms.map((s) => s.platform).contains(element);
          }),
          focusNode: platformInput.value.focusNode,
          onSelected: (GamePlatform value) {
            setState(() {
              // update the platform of this currently selected item
              _selectedPlatforms[platformInput.key].platform = value;
              _selectedPlatforms[platformInput.key].focusNode.unfocus();
              if (_selectedPlatforms.length > platformInput.key) {
                _selectedPlatforms.add(PlatformSearchInput());
              }
            });
          },
          isRemovable: platformInput.value.platform != null,
          onRemove: () {
            setState(() {
              _selectedPlatforms.removeAt(platformInput.key);
            });
          },
          validator: (value) {
            if (platformInput.key != 0) return null;
            if (value == null || value.isEmpty) {
              return 'Wo kann man das Spiel den spielen?';
            }
            return null;
          },
        );
      },
    ).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Bearbeiten')),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.sports_esports),
                  hintText: 'NieR: Automata, Super Mario Odyssey, ...',
                  labelText: 'Name*',
                ),
                controller: _nameController,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                    label: Text('Status*'),
                    icon: Icon(Icons.library_add_check)),
                items:
                    GameState.values.map<DropdownMenuItem<GameState>>((state) {
                  return DropdownMenuItem<GameState>(
                    value: state,
                    child: Text(GameStates.gameStateToString(state)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGameState = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Ohne Status kommen wir nicht weiter.';
                  }
                  return null;
                },
                value: _selectedGameState,
              ),
              Column(
                children: platformInputs,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.euro),
                  labelText: 'Preis',
                ),
                keyboardType: TextInputType.number,
                controller: _priceController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.description),
                  labelText: 'Anmerkungen',
                  hintText: 'Ausgeliehen, inkl. DLC, ...',
                ),
                controller: _notesController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month),
                  labelText: 'Erscheinungsdatum',
                ),
                onTap: () async {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(FocusNode());

                  // show date-picker
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1970, 1, 1),
                    lastDate: DateTime.now().add(const Duration(days: 5 * 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      // set the picked value
                      _releaseDate = picked;
                      _releaseDateController.text = _releaseDate != null
                          ? DateFormat.yMd().format(_releaseDate!)
                          : '';
                    });
                  }
                },
                controller: _releaseDateController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.emoji_events),
                  labelText: 'Metacritic-Score',
                ),
                keyboardType: TextInputType.number,
                controller: _metacriticScoreController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.image),
                  labelText: 'Hintergrundbild',
                ),
                controller: _backgroundImageController,
              ),
              // TODO: Spiel suchen und "ID (Name)" als Select hier anzeigen
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.fingerprint),
                  labelText: 'Rawg-Game-ID',
                ),
                controller: _rawgGameIdController,
              ),
              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 160,
                        child: DropdownButtonFormField2<AgeRestriction>(
                          decoration: const InputDecoration(
                            labelText: 'Altersfreigabe',
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            icon: Icon(Icons.cake),
                          ),
                          isExpanded: true,
                          itemHeight: 70,
                          buttonHeight: 160,
                          items: AgeRestriction.values
                              .sublist(1)
                              .map<DropdownMenuItem<AgeRestriction>>(
                                  (AgeRestriction ageRestriction) {
                            return DropdownMenuItem<AgeRestriction>(
                              value: ageRestriction,
                              child: Center(
                                child: AgeRestrictionWidget(
                                  ageRestriction: ageRestriction,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: ((AgeRestriction? value) {
                            setState(() {
                              _ageRestrictionController = value;
                            });
                          }),
                          value: _ageRestrictionController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // accumulate all changes in a game object
                          Game editedGame = Game.from(widget.game);
                          editedGame.title = _nameController.text;
                          if (_selectedGameState != null) {
                            editedGame.gameState = _selectedGameState!;
                          }
                          editedGame.platforms = _selectedPlatforms
                              .where((selection) => selection.platform != null)
                              .map((platform) =>
                                  platform.platform?.name ??
                                  'Unbekannte Platform')
                              .toList();
                          editedGame.price =
                              double.tryParse(_priceController.text);
                          editedGame.notes = _notesController.text;
                          editedGame.releaseDate = _releaseDate;
                          editedGame.metacriticScore =
                              int.tryParse(_metacriticScoreController.text);
                          editedGame.backgroundImage =
                              _backgroundImageController.text;
                          editedGame.rawgGameId =
                              int.tryParse(_rawgGameIdController.text);
                          editedGame.ageRestriction = _ageRestrictionController;

                          // update the game in storage
                          await Storage().addOrUpdateGame(editedGame);
                          if (!mounted) return;
                          Navigator.pop(context);
                        },
                        child: const Text('Speichern'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
