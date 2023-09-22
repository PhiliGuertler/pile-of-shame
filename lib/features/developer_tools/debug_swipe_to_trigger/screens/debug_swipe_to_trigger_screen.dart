import 'package:flutter/material.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/swipe_to_trigger.dart';

class DebugSwipeToTriggerScreen extends StatelessWidget {
  const DebugSwipeToTriggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text("Swipe to trigger"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 42,
            child: SwipeToTrigger(
              triggerOffset: 0.25,
              child: Container(
                color: Colors.orange,
                child: const Icon(Icons.text_snippet),
              ),
              rightWidget: (triggerProgress) {
                double triggerOvershoot =
                    (triggerProgress - 1.0).clamp(0, double.infinity);
                double untilTrigger = triggerProgress.clamp(0.0, 1.0);
                return Container(
                  color: Colors.red,
                  child: Transform.scale(
                    scale: 1.0 + triggerOvershoot,
                    child: Icon(
                      Icons.favorite,
                      color: HSLColor.fromColor(Colors.red)
                          .withLightness(0.5 + untilTrigger * 0.5)
                          .toColor(),
                    ),
                  ),
                );
              },
              onTriggerRight: () {
                debugPrint("Heart!");
              },
              leftWidget: (triggerProgress) {
                double triggerOvershoot =
                    (triggerProgress - 1.0).clamp(0, double.infinity);
                double untilTrigger = triggerProgress.clamp(0.0, 1.0);
                return Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Transform.scale(
                    scale: 1.0 + triggerOvershoot,
                    child: Icon(
                      Icons.open_in_full,
                      color: HSLColor.fromColor(
                              Theme.of(context).colorScheme.surfaceVariant)
                          .withLightness(0.5 + untilTrigger * 0.5)
                          .toColor(),
                    ),
                  ),
                );
              },
              onTriggerLeft: () {
                debugPrint("Grow!");
              },
            ),
          ),
        ],
      ),
    );
  }
}
