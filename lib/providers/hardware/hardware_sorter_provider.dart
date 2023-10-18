import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/models/hardware_sorting.dart';
import 'package:pile_of_shame/providers/mixins/persistable_mixin.dart';
import 'package:pile_of_shame/utils/sorter_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hardware_sorter_provider.g.dart';

@Riverpod(keepAlive: true)
class SortHardware extends _$SortHardware with Persistable {
  static const String storageKey = "sorter-hardware";

  @override
  FutureOr<HardwareSorting> build() async {
    final storedJSON = await loadFromStorage(storageKey);
    if (storedJSON != null) {
      return HardwareSorting.fromJson(storedJSON);
    }
    return const HardwareSorting();
  }

  Future<void> setSorting(HardwareSorting sorting) async {
    state = await AsyncValue.guard(() async {
      await persistJSON(storageKey, sorting.toJson());
      return sorting;
    });
  }
}

@riverpod
FutureOr<List<VideoGameHardware>> applyHardwareSorting(
  ApplyHardwareSortingRef ref,
  List<VideoGameHardware> hardware,
) async {
  final sorting = await ref.watch(sortHardwareProvider.future);

  return SorterUtils.sortHardware(hardware, sorting);
}
