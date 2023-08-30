import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

enum USK {
  usk0(age: 0, color: Colors.white),
  usk6(age: 6, color: Colors.yellow),
  usk12(age: 12, color: Colors.green),
  usk16(age: 16, color: Colors.blue),
  usk18(age: 18, color: Colors.red),
  ;

  final int age;
  final Color color;

  const USK({
    required this.age,
    required this.color,
  });

  String toRatedString(BuildContext context) {
    return AppLocalizations.of(context)!.ratedN(age.toString());
  }
}
