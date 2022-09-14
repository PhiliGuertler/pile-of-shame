import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/age_restrictions.dart';
import 'package:pile_of_shame/src/persistance/storage.dart';
import 'package:pile_of_shame/src/widgets/age_restriction.dart';

import '../models/game.dart';

// TODO: Move these platforms to a (potentially growing) list in a persisted file
final platforms = [
  // Nintendo
  'NES',
  'SNES',
  'Nintendo 64',
  'Gamecube',
  'Wii',
  'Virtual Console Wii',
  'Nintendo Switch',
  'Nintendo Switch Online',
  'Gameboy',
  'Gameboy Color',
  'Gameboy Advance',
  'Nintendo DS',
  'Nintendo 3DS',
  'Virtual Console 3DS',
  // PC
  'PC',
  'PC: Steam',
  'PC: Gog',
  'PC: U-Play',
  'PC: Epic',
  'PC: Twitch',
  'VR: Steam',
  // Sony
  'Playstation Portable',
  'Playstation Vita',
  'Playstation',
  'Playstation 2',
  'Playstation 3',
  'Playstation 4',
  'Playstation 4 (PS+)',
  'Playstation 5',
  'Playstation 5 (PS+)',
  'Playstation VR',
  'Playstation VR 2',
  // Microsoft
  'PC: XBox (Game Pass)',
  'XBox',
  'XBox 360',
  'XBox One',
  'XBox Series X/S',
  // Misc
  'Emulator (Dolphin)',
  'Emulator (PCSX2)',
  'Emulator (DeSMume)',
];

class AddGameScreen extends StatefulWidget {
  const AddGameScreen({super.key});

  @override
  State<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();

  AgeRestriction? _selectedAge;
  String? _selectedPlatform;
  String? _selectedName;
  double? _selectedPrice;
  String? _selectedNotes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spiel hinzufügen'),
      ),
      body: Container(
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
                  return null;
                },
              ),
              Autocomplete(
                onSelected: (option) {
                  setState(
                    () {
                      _selectedPlatform = option;
                    },
                  );
                },
                fieldViewBuilder: ((context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.videogame_asset),
                      hintText: 'Wii, Nintendo Switch, PC, ...',
                      labelText: 'Platform*',
                    ),
                    onChanged: (value) {
                      _selectedPlatform = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wo kann man das Spiel den spielen?';
                      }
                      return null;
                    },
                  );
                }),
                optionsBuilder: ((textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return platforms.where((platform) {
                    return platform
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                }),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.sell),
                  labelText: 'Preis',
                  prefixIcon: Icon(Icons.euro),
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
                              platform: _selectedPlatform!,
                              price: _selectedPrice,
                              ageRestriction: _selectedAge,
                              notes: _selectedNotes,
                            );

                            // get the list of games from storage
                            Storage().readGames().then((gameList) {
                              gameList.add(game);
                              Storage().writeGames(gameList).then(
                                (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Spiel $_selectedName hinzugefügt.')),
                                  );

                                  Navigator.pop(context);
                                },
                              );
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
    );
  }
}
