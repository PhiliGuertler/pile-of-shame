import 'package:flutter/material.dart';

enum AgeRestriction {
  unknown,
  usk0,
  usk6,
  usk12,
  usk16,
  usk18,
}

class AgeRestrictions {
  static Color getAgeRestictionColor(AgeRestriction ageRestriction) {
    switch (ageRestriction) {
      case AgeRestriction.usk0:
        return Colors.white;
      case AgeRestriction.usk6:
        return Colors.yellow;
      case AgeRestriction.usk12:
        return Colors.green;
      case AgeRestriction.usk16:
        return Colors.blue;
      case AgeRestriction.usk18:
        return Colors.red;
      case AgeRestriction.unknown:
      default:
        return Colors.grey;
    }
  }

  static String getAgeRestrictionText(AgeRestriction ageRestriction) {
    switch (ageRestriction) {
      case AgeRestriction.usk0:
        return "0";
      case AgeRestriction.usk6:
        return "6";
      case AgeRestriction.usk12:
        return "12";
      case AgeRestriction.usk16:
        return "16";
      case AgeRestriction.usk18:
        return "18";
      case AgeRestriction.unknown:
      default:
        return "???";
    }
  }
}
