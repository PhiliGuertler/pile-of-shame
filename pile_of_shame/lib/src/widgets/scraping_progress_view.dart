import 'package:flutter/material.dart';

class ScrapingProgressView extends StatelessWidget {
  const ScrapingProgressView(
      {super.key,
      required this.currentItem,
      required this.totalItems,
      required this.currentItemName});

  final int currentItem;
  final int totalItems;
  final String currentItemName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Center(
          child: Stack(children: [
            CircularProgressIndicator(
              value: currentItem / totalItems,
              strokeWidth: 5.0,
            ),
            const CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(currentItemName),
        ),
      ]),
    );
  }
}
