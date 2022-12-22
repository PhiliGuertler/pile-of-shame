import 'package:flutter/material.dart';

/// Displays a rich-text that highlights the first occourance of searchTerm in a given string
/// Inclusion checks will be performed case-insensitively.
/// @example
/// searchTerm = 'Tt', string = 'flutter' ==> 'flu*tt*er' (the part between * will be bold and in primary color)
class SearchResultHighlight extends StatelessWidget {
  const SearchResultHighlight(
      {super.key, required this.searchTerm, required this.string});

  /// the search-term that is supposed to be highlighted in the input string
  final String searchTerm;

  /// the string in which to find and highlight the search-term
  final String string;

  @override
  Widget build(BuildContext context) {
    final boldnessIndex =
        string.toLowerCase().indexOf(searchTerm.toLowerCase());
    if (boldnessIndex == -1) {
      return Text(string);
    }
    return RichText(
      text: TextSpan(
        text: string.substring(0, boldnessIndex),
        children: [
          TextSpan(
            text: string.substring(
                boldnessIndex, boldnessIndex + searchTerm.length),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
          TextSpan(
            text: string.substring(
              boldnessIndex + searchTerm.length,
            ),
          ),
        ],
      ),
    );
  }
}
