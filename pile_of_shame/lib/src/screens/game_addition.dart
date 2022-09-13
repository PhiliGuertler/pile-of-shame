import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pile_of_shame/src/models/age_restrictions.dart';
import 'package:pile_of_shame/src/widgets/age_restriction.dart';

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
  AgeRestriction? _selectedAge;

  final _formKey = GlobalKey<FormState>();

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
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.sports_esports),
                              hintText:
                                  'NieR: Automata, Super Mario Odyssey, ...',
                              labelText: 'Name',
                            ),
                          ),
                          Autocomplete(
                            fieldViewBuilder: ((context, textEditingController,
                                focusNode, onFieldSubmitted) {
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.videogame_asset),
                                  hintText: 'Wii, Nintendo Switch, PC, ...',
                                  labelText: 'Platform',
                                ),
                              );
                            }),
                            optionsBuilder: ((textEditingValue) {
                              if (textEditingValue.text == '') {
                                return const Iterable<String>.empty();
                              }
                              return platforms.where((platform) {
                                return platform.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase());
                              });
                            }),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.sell),
                              labelText: 'Preis',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) return null;
                              return double.tryParse(value) != null
                                  ? null
                                  : 'Komm schon, gib eine gültige Zahl ein!';
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    height: 120,
                    child: DropdownButtonHideUnderline(
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
                        buttonHeight: 120,
                        dropdownWidth: 100,
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
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Hinzufügen'))
            ],
          ),
        ),
      ),
    );
  }
}
