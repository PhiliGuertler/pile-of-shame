import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pile_of_shame/features/settings/appearance/screens/appearance_screen.dart';
import 'package:pile_of_shame/features/settings/language/screens/language_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                AppLocalizations.of(context)!.appSettings,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SegmentedActionCard(
              items: [
                SegmentedActionCardItem(
                  leading: const Icon(Icons.dark_mode),
                  title: Text(AppLocalizations.of(context)!.appearance),
                  subtitle:
                      Text(AppLocalizations.of(context)!.comeToTheDarkSide),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AppearanceScreen(),
                      ),
                    );
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.translate),
                  title: Text(AppLocalizations.of(context)!.language),
                  subtitle:
                      Text(AppLocalizations.of(context)!.languageSubtitle),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LanguageScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(defaultPaddingX),
                child: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        'App-Version: ${snapshot.data!.version} (${snapshot.data!.buildNumber})',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
