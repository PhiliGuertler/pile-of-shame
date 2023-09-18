import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';

class DebugGamePlatformIconsScreen extends StatelessWidget {
  const DebugGamePlatformIconsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text("Game Platform Icons"),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList.builder(
              itemBuilder: (context, index) {
                final platform = GamePlatform.values[index];
                return ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: defaultPaddingX,
                        right: defaultPaddingX,
                        top: 16.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        platform.localizedName(AppLocalizations.of(context)!),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: Image.asset(platform.iconPath),
                    )
                  ],
                );
              },
              itemCount: GamePlatform.values.length,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: defaultPaddingX,
                    right: defaultPaddingX,
                    top: 16.0,
                    bottom: 24.0),
                child: Text(
                  "Total Entries: ${GamePlatform.values.length}",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
