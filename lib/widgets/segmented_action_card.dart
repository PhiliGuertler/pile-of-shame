import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/utils/constants.dart';

part 'segmented_action_card.freezed.dart';

@freezed
class SegmentedActionCardItem with _$SegmentedActionCardItem {
  const factory SegmentedActionCardItem({
    Widget? title,
    Widget? subtitle,
    Color? tileColor,
    Widget? leading,
    @Default(Icon(Icons.navigate_next_rounded)) Widget? trailing,
    VoidCallback? onTap,
  }) = _SegmentedActionCardItem;
}

class SegmentedActionCard extends StatelessWidget {
  final List<SegmentedActionCardItem> items;

  const SegmentedActionCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(
      Radius.circular(defaultBorderRadius),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          // due to some weird bug we use box shadow instead of border to color
          // the boundaries of the container.
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).dividerColor,
              spreadRadius: 0,
              blurRadius: 1,
            )
          ],
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            // actually we only want to paint the left, bottom and top side,
            // which is not supported by RoundedRectangleBorder. Thus, we wrap
            // this card in a container that paints these borders instead.
            borderRadius: borderRadius,
          ),
          margin: EdgeInsets.zero,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final isDivider = 0 != index & 0x1;
              if (isDivider) {
                return const Divider(
                  height: 0,
                );
              }

              final bool isFirstItem = index == 0;
              final bool isLastItem = index == items.length * 2 - 2;
              ShapeBorder? shape;
              if (isFirstItem || isLastItem) {
                const roundedRadius = Radius.circular(defaultBorderRadius);

                shape = RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: isFirstItem ? roundedRadius : Radius.zero,
                  topRight: isFirstItem ? roundedRadius : Radius.zero,
                  bottomLeft: isLastItem ? roundedRadius : Radius.zero,
                  bottomRight: isLastItem ? roundedRadius : Radius.zero,
                ));
              }

              final item = items[index ~/ 2];

              return ListTile(
                shape: shape,
                leading: item.leading,
                trailing: item.trailing,
                title: item.title,
                subtitle: item.subtitle,
                onTap: item.onTap,
                tileColor: item.tileColor,
              );
            },
            itemCount: items.length * 2 - 1,
          ),
        ),
      ),
    );
  }
}
