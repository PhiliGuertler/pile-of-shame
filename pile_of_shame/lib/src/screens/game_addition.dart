import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/age_restrictions.dart';
import 'package:pile_of_shame/src/models/game_platform.dart';
import 'package:pile_of_shame/src/persistance/storage.dart';
import 'package:pile_of_shame/src/widgets/age_restriction.dart';
import 'package:pile_of_shame/src/widgets/game_platform_autocomplete.dart';

import '../models/game.dart';

class PlatformSearchInput {
  PlatformSearchInput({this.platform})
      : textEditingController = TextEditingController(),
        focusNode = FocusNode();

  TextEditingController textEditingController;
  FocusNode focusNode;
  GamePlatform? platform;
}

class AddGameScreen extends StatefulWidget {
  const AddGameScreen({super.key});

  @override
  State<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();

  AgeRestriction? _selectedAge;
  final List<PlatformSearchInput> _selectedPlatforms = [PlatformSearchInput()];
  String? _selectedName;
  double? _selectedPrice;
  String? _selectedNotes;

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
      appBar: AppBar(
        title: const Text('Spiel hinzufügen'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.sports_esports),
                    hintText: 'NieR: Automata, Super Mario Odyssey, ...',
                    labelText: 'Name*',
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        _selectedName = value;
                      },
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Komm schon, gib mir einen Namen.';
                    }
                    // TODO: Display an error if the entered name is already in use
                    return null;
                  },
                ),
                Column(
                  children: platformInputs,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.euro),
                    labelText: 'Preis',
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        _selectedPrice = double.tryParse(value);
                      },
                    );
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return null;
                    return double.tryParse(value) != null
                        ? null
                        : 'Komm schon, gib eine gültige Zahl ein!';
                  },
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.description),
                    labelText: 'Anmerkungen',
                    hintText: 'Ausgeliehen, inkl. DLC, ...',
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        _selectedNotes = value;
                      },
                    );
                  },
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
                            value: _selectedAge,
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
                                _selectedAge = value;
                              });
                            }),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              final Game game = Game(
                                title: _selectedName!,
                                platforms: _selectedPlatforms
                                    .where((selection) =>
                                        selection.platform != null)
                                    .map((platform) =>
                                        platform.platform?.name ??
                                        'Unbekannte Platform')
                                    .toList(),
                                price: _selectedPrice,
                                ageRestriction: _selectedAge,
                                notes: _selectedNotes,
                              );

                              // get the list of games from storage
                              Storage().addOrUpdateGame(game).then((result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result
                                        ? 'Spiel $_selectedName hinzugefügt.'
                                        : 'Spiel $_selectedName aktualisiert.'),
                                  ),
                                );
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: const Text('Hinzufügen'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
