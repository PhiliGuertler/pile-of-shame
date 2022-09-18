import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../models/age_restrictions.dart';
import '../models/game.dart';
import '../models/game_platform.dart';
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

  @override
  void initState() {
    super.initState();
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
        child: Form(
            child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.sports_esports),
                hintText: 'NieR: Automata, Super Mario Odyssey, ...',
                labelText: 'Name*',
              ),
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
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.description),
                labelText: 'Anmerkungen',
                hintText: 'Ausgeliehen, inkl. DLC, ...',
              ),
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
                    // TODO: set the picked value
                  });
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.emoji_events),
                labelText: 'Metacritic-Score',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.image),
                labelText: 'Hintergrundbild',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.fingerprint),
                labelText: 'Rawg-Game-ID',
              ),
              initialValue:
                  'TODO: Spiel suchen und "ID (Name)" als Select hier anzeigen',
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
                        ),
                        isExpanded: true,
                        itemHeight: 70,
                        buttonHeight: 160,
                        // value: _selectedAge,
                        items: AgeRestriction.values
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
                            // _selectedAge = value;
                          });
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement me
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
    );
  }
}
