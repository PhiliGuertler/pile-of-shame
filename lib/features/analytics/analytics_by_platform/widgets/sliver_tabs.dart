import 'package:flutter/material.dart';

class SliverTabs extends StatelessWidget {
  const SliverTabs({super.key, required this.tabs});

  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverPersistentTabsHeaderDelegate(
        tabs: tabs,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class _SliverPersistentTabsHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final List<Tab> tabs;
  final Color color;

  const _SliverPersistentTabsHeaderDelegate({
    required this.tabs,
    required this.color,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 48.0,
      color: color,
      child: TabBar(tabs: tabs),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 48.0;

  @override
  // TODO: implement minExtent
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(
    covariant _SliverPersistentTabsHeaderDelegate oldDelegate,
  ) {
    return tabs != oldDelegate.tabs;
  }
}
