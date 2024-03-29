import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/app_currency.dart';
import 'package:pile_of_shame/providers/currency_provider.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';

class CurrencyScreen extends ConsumerWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencySettings = ref.watch(currencySettingsProvider);

    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: AppBar(
        title: Text(l10n.currency),
      ),
      body: ListView(
        children: [
          ...CurrencySymbols.values.map(
            (currency) => RadioListTile(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: ImageContainer(
                        child: Center(
                          child: Text(
                            currency.symbol,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(currency.localeName(l10n)),
                ],
              ),
              onChanged: (value) {
                ref
                    .read(currencySettingsProvider.notifier)
                    .setCurrencySymbol(currency);
              },
              controlAffinity: ListTileControlAffinity.trailing,
              groupValue: currencySettings.asData?.value.currency,
              value: currency,
            ),
          ),
        ],
      ),
    );
  }
}
