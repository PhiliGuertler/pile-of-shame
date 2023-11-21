import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/models/app_currency.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currency_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrencySettings extends _$CurrencySettings with Persistable {
  static const String storageKey = 'currency';

  @override
  FutureOr<AppCurrency> build() async {
    final storedJSON = await loadFromStorage(storageKey);
    if (storedJSON != null) {
      return AppCurrency.fromJson(storedJSON);
    }
    return const AppCurrency();
  }

  Future<void> setCurrencySymbol(CurrencySymbols symbol) async {
    state = await AsyncValue.guard(() async {
      final AppCurrency update = state.maybeWhen(
        data: (data) => data.copyWith(currency: symbol),
        orElse: () => AppCurrency(currency: symbol),
      );
      await persistJSON(storageKey, update.toJson());
      return update;
    });
  }
}
