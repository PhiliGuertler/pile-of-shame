import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/hardware/hardware_sorter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hardware_provider.g.dart';

@riverpod
FutureOr<List<VideoGameHardware>> hardware(
  HardwareRef ref,
) async {
  final database = await ref.watch(databaseProvider.future);
  return database.hardware;
}

@riverpod
FutureOr<bool> hasHardware(
  HasHardwareRef ref,
) async {
  final hardware = await ref.watch(hardwareProvider.future);
  return hardware.isNotEmpty;
}

@riverpod
FutureOr<List<GamePlatform>> hardwarePlatforms(
  HardwarePlatformsRef ref,
) async {
  final hardware = await ref.watch(hardwareProvider.future);

  final Set<GamePlatform> platformSet = {};
  for (final entry in hardware) {
    platformSet.add(entry.platform);
  }

  final List<GamePlatform> result = platformSet.toList();
  result.sort((a, b) => a.index.compareTo(b.index));

  return result;
}

@riverpod
FutureOr<List<VideoGameHardware>> hardwareByPlatform(
  HardwareByPlatformRef ref,
  GamePlatform platform,
) async {
  final allHardware = await ref.watch(hardwareProvider.future);

  final List<VideoGameHardware> hardware = [];

  for (final h in allHardware) {
    if (h.platform == platform) {
      hardware.add(h);
    }
  }

  hardware.sort((a, b) => a.name.compareTo(b.name));

  return hardware;
}

@riverpod
FutureOr<List<VideoGameHardware>> hardwareByPlatformFamily(
  HardwareByPlatformFamilyRef ref,
  GamePlatformFamily family,
) async {
  final allHardware = await ref.watch(hardwareProvider.future);

  final List<VideoGameHardware> hardware = [];

  for (final h in allHardware) {
    if (h.platform.family == family) {
      hardware.add(h);
    }
  }

  hardware.sort((a, b) => a.name.compareTo(b.name));

  return hardware;
}

@riverpod
FutureOr<VideoGameHardware> hardwareById(
  HardwareByIdRef ref,
  String id,
) async {
  final allHardware = await ref.watch(hardwareProvider.future);

  try {
    return allHardware.singleWhere((element) => element.id == id);
  } catch (error) {
    throw Exception("No hardware with id '$id' found");
  }
}

@riverpod
FutureOr<List<VideoGameHardware>> sortedHardwareByPlatform(
  SortedHardwareByPlatformRef ref,
  GamePlatform platform,
) async {
  final hardware = await ref.watch(hardwareByPlatformProvider(platform).future);

  return await ref.watch(applyHardwareSortingProvider(hardware).future);
}
