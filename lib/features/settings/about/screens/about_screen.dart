import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/widgets/image_container.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.aboutThisApp)),
      body: SafeArea(
        child: SegmentedActionCard(
          items: [
            SegmentedActionCardItem(
              title: Text(AppLocalizations.of(context)!.githubRepository),
              trailing: const Icon(Icons.open_in_new),
              onTap: () {
                // TODO: Open Github repository
              },
            ),
            SegmentedActionCardItem(
              title: Text(AppLocalizations.of(context)!.licenses),
              trailing: const Icon(Icons.library_books),
              onTap: () async {
                final info = await PackageInfo.fromPlatform();
                if (context.mounted) {
                  showAboutDialog(
                    context: context,
                    applicationIcon: ImageContainer(
                        child: Image.asset('assets/app/logo.png')),
                    applicationName: info.appName,
                    applicationVersion: "${info.version} (${info.buildNumber})",
                  );
                }
              },
            ),
            SegmentedActionCardItem(
              title: Text(AppLocalizations.of(context)!.imageCredit),
              subtitle: Text(AppLocalizations.of(context)!
                  .imagesOfControllersHaveBeenCreatedUsingMidjourney),
              trailing: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
