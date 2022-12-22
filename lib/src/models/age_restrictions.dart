import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

enum AgeRestriction {
  @JsonValue(0)
  none,
  @JsonValue(1)
  unknown,
  @JsonValue(2)
  usk0,
  @JsonValue(3)
  usk6,
  @JsonValue(4)
  usk12,
  @JsonValue(5)
  usk16,
  @JsonValue(6)
  usk18,
}

class AgeRestrictions {
  // private constructor, as this class is not instantiable
  AgeRestrictions._();

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

  static int compareAgeRestrictions(AgeRestriction a, AgeRestriction b) {
    return a.index.compareTo(b.index);
  }
}
