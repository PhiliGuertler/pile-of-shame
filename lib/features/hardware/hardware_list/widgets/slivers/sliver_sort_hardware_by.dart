import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/hardware_sorting.dart';

class SliverSortHardwareBy extends StatelessWidget {
  const SliverSortHardwareBy({
    super.key,
    required this.activeStrategy,
    required this.onChanged,
  });

  final SortStrategyHardware activeStrategy;
  final void Function(SortStrategyHardware strategy) onChanged;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        final SortStrategyHardware strategy =
            SortStrategyHardware.values[index];
        final isSelected = strategy == activeStrategy;
        return RadioListTile.adaptive(
          groupValue: activeStrategy,
          value: strategy,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  strategy.toIcon(),
                  color:
                      isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              Flexible(
                child: Text(
                  strategy.toLocaleString(context),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              ),
            ],
          ),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          controlAffinity: ListTileControlAffinity.trailing,
        );
      },
      itemCount: SortStrategyHardware.values.length,
    );
  }
}
