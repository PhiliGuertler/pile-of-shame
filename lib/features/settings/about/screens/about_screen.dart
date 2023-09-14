import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/image_container.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.aboutThisApp)),
      body: SafeArea(
        child: SegmentedActionCard(
          items: [
            SegmentedActionCardItem(
              title: Text(AppLocalizations.of(context)!.githubRepository),
              subtitle:
                  const Text("https://github.com/PhiliGuertler/pile-of-shame"),
              trailing: const Icon(Icons.open_in_new),
              onTap: () async {
                if (!await launchUrl(
                  Uri.parse("https://github.com/PhiliGuertler/pile-of-shame"),
                )) {
                  throw Exception("Could not launch url");
                }
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
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                        child: SizedBox(
                          height: 200,
                          child: Image.asset(
                            'assets/misc/loading.webp',
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
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
