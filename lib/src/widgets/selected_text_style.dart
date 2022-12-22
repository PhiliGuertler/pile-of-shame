import 'package:flutter/material.dart';

class SelectedTextStyle extends StatelessWidget {
  const SelectedTextStyle(
      {super.key, required this.isSelected, required this.text});

  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : null),
    );
  }
}
