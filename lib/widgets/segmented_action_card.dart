import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/providers/debug_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';

part 'segmented_action_card.freezed.dart';

@freezed
class SegmentedActionCardItem with _$SegmentedActionCardItem {
  const factory SegmentedActionCardItem({
    Key? key,
    Widget? title,
    Widget? subtitle,
    Color? tileColor,
    Widget? leading,
    @Default(Icon(Icons.navigate_next_rounded)) Widget? trailing,

    /// Generic tap handler. Cannot be set if openBuilder is also set.
    VoidCallback? onTap,

    /// Tap handler that triggers a transition to the returned widget of this function. Cannot be set if onTap is also set.
    Widget Function(BuildContext, void Function({Object? returnValue}))?
        openBuilderOnTap,

    // for debugging purposes
    @Default(false) bool isDebugItem,
  }) = _SegmentedActionCardItem;

  factory SegmentedActionCardItem.debug({
    Key? key,
    Widget? title,
    Widget? subtitle,
    Color? tileColor,
    Widget? leading,
    Widget? trailing = const Icon(Icons.navigate_next_rounded),

    /// Generic tap handler. Cannot be set if openBuilder is also set.
    VoidCallback? onTap,

    /// Tap handler that triggers a transition to the returned widget of this function. Cannot be set if onTap is also set.
    Widget Function(BuildContext, void Function({Object? returnValue}))?
        openBuilderOnTap,
  }) {
    return SegmentedActionCardItem(
      key: key,
      title: title,
      subtitle: subtitle,
      tileColor: Colors.orange.shade800,
      leading: leading,
      onTap: onTap,
      openBuilderOnTap: openBuilderOnTap,
      trailing: trailing,
      isDebugItem: true,
    );
  }
}

class SegmentedActionCard extends ConsumerWidget {
  final List<SegmentedActionCardItem> items;

  const SegmentedActionCard({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const borderRadius = Radius.circular(defaultBorderRadius);
    final isDebugMode = ref.watch(debugFeatureAccessProvider);

    final List<SegmentedActionCardItem> filteredItems = isDebugMode
        ? items
        : items.where((element) => !element.isDebugItem).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(borderRadius),
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(borderRadius),
          ),
          margin: EdgeInsets.zero,
          child: ListView.builder(
            // Some weird bug leads to extra space at the top if the padding is not set
            padding: EdgeInsets.zero,
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
              final bool isLastItem = index == filteredItems.length * 2 - 2;
              late ShapeBorder shape;
              if (isFirstItem || isLastItem) {
                shape = RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: isFirstItem ? borderRadius : Radius.zero,
                    topRight: isFirstItem ? borderRadius : Radius.zero,
                    bottomLeft: isLastItem ? borderRadius : Radius.zero,
                    bottomRight: isLastItem ? borderRadius : Radius.zero,
                  ),
                );
              } else {
                shape = const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero);
              }

              final item = filteredItems[index ~/ 2];

              // Only allow either onTap or openBuilder to be set, not both at the same time
              assert((item.onTap != null && item.openBuilderOnTap == null) ||
                  (item.onTap == null && item.openBuilderOnTap != null) ||
                  (item.onTap == null && item.openBuilderOnTap == null));

              if (item.openBuilderOnTap != null) {
                return OpenContainer(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionType: ContainerTransitionType.fadeThrough,
                  openColor: Theme.of(context).colorScheme.background,
                  closedColor: item.tileColor ??
                      Theme.of(context).colorScheme.background,
                  closedShape: shape,
                  closedBuilder: (context, openContainer) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: defaultPaddingX - 8.0),
                    shape: shape,
                    leading: item.leading,
                    trailing: item.trailing,
                    title: item.title,
                    subtitle: item.subtitle,
                    onTap: openContainer,
                    tileColor: item.tileColor,
                  ),
                  openBuilder: item.openBuilderOnTap!,
                );
              } else {
                return ListTile(
                  key: item.key,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: defaultPaddingX - 8.0),
                  shape: shape,
                  leading: item.leading,
                  trailing: item.trailing,
                  title: item.title,
                  subtitle: item.subtitle,
                  onTap: item.onTap,
                  tileColor: item.tileColor,
                );
              }
            },
            itemCount: filteredItems.length * 2 - 1,
          ),
        ),
      ),
    );
  }
}
