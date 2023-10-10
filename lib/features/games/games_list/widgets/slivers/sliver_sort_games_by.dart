import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/game_sorting.dart';

class SliverSortGamesBy extends StatelessWidget {
  const SliverSortGamesBy({
    super.key,
    required this.activeStrategy,
    required this.onChanged,
  });

  final SortStrategy activeStrategy;
  final void Function(SortStrategy strategy) onChanged;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        final SortStrategy strategy = SortStrategy.values[index];
        return RadioListTile.adaptive(
          groupValue: activeStrategy,
          value: strategy,
          title: Text(strategy.toLocaleString(context)),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          controlAffinity: ListTileControlAffinity.trailing,
        );
      },
      itemCount: SortStrategy.values.length,
    );
  }
}
