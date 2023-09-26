import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/game_platform_analytics.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/game_platform_family_analytics.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/play_status_analytics.dart';

class AnalyticsRootContentScreen extends ConsumerStatefulWidget {
  const AnalyticsRootContentScreen({super.key});

  @override
  ConsumerState<AnalyticsRootContentScreen> createState() =>
      _AnalyticsRootContentScreenState();
}

class _AnalyticsRootContentScreenState
    extends ConsumerState<AnalyticsRootContentScreen> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: TabBarView(
        children: [
          GamePlatformFamilyAnalytics(),
          GamePlatformAnalytics(),
          PlayStatusAnalytics(),
        ],
      ),
    );
  }
}
