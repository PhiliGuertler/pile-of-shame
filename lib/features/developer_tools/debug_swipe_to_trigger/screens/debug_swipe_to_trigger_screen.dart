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
              child: Container(
                color: Colors.orange,
                child: const Icon(Icons.text_snippet),
              ),
              leftWidget: (triggerProgress) {
                return Container(
                  color: HSLColor.fromColor(Colors.red)
                      .withSaturation(triggerProgress % 1.0)
                      .toColor(),
                );
              },
              onTriggerLeft: () {
                debugPrint("Triggered left!");
              },
            ),
          ),
        ],
      ),
    );
  }
}
