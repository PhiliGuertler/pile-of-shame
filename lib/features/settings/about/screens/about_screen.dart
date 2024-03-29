import 'package:flutter/material.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/fade_in_image_asset.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.aboutThisApp)),
      body: SafeArea(
        child: ListView(
          children: [
            SegmentedActionCard(
              items: [
                SegmentedActionCardItem(
                  title: Text(AppLocalizations.of(context)!.githubRepository),
                  subtitle: const Text(
                    "https://github.com/PhiliGuertler/pile-of-shame",
                  ),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () async {
                    if (!await launchUrl(
                      Uri.parse(
                        "https://github.com/PhiliGuertler/pile-of-shame",
                      ),
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
                        applicationIcon: const ImageContainer(
                          child: FadeInImageAsset(asset: ImageAssets.appLogo),
                        ),
                        applicationName: info.appName,
                        applicationVersion:
                            "${info.version} (${info.buildNumber})",
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                            child: const SizedBox(
                              height: 200,
                              child: FadeInImageAsset(
                                asset: ImageAssets.loading,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                SegmentedActionCardItem(
                  title: Text(AppLocalizations.of(context)!.imageCredit),
                  subtitle: Text(
                    AppLocalizations.of(context)!
                        .imagesOfControllersHaveBeenCreatedUsingMidjourney,
                  ),
                  trailing: const SizedBox(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 16.0,
              ),
              child: Text(AppLocalizations.of(context)!.pileOfShameWhatAreYou),
            ),
          ],
        ),
      ),
    );
  }
}
