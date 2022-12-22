import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'code')
enum AgeRestriction {
  // Age-restriction values
  usk0(0, '0', Colors.white),
  usk6(1, '6', Colors.yellow),
  usk12(2, '12', Colors.green),
  usk16(3, '16', Colors.blue),
  usk18(4, '18', Colors.red),
  unknown(5, '???', Colors.grey);

  // Members of an Age Restriction
  final int code;
  final String displayValue;
  final Color color;
  const AgeRestriction(this.code, this.displayValue, this.color);
}
