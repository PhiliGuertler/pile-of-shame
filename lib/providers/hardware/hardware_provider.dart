import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/hardware/hardware_sorter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hardware_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<VideoGameHardware>> hardware(
  Ref ref,
) async {
  final database = await ref.watch(databaseProvider.future);
  return database.hardware;
}

@Riverpod(keepAlive: true)
FutureOr<bool> hasHardware(
  Ref ref,
) async {
  final hardware = await ref.watch(hardwareProvider.future);
  return hardware.isNotEmpty;
}

@Riverpod(keepAlive: true)
FutureOr<List<GamePlatform>> hardwarePlatforms(
  Ref ref,
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

@Riverpod(keepAlive: true)
FutureOr<List<VideoGameHardware>> hardwareByPlatform(
  Ref ref,
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

@Riverpod(keepAlive: true)
FutureOr<List<VideoGameHardware>> hardwareByPlatformFamily(
  Ref ref,
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

@Riverpod(keepAlive: true)
FutureOr<VideoGameHardware> hardwareById(
  Ref ref,
  String id,
) async {
  final allHardware = await ref.watch(hardwareProvider.future);

  try {
    return allHardware.singleWhere((element) => element.id == id);
  } catch (error) {
    throw Exception("No hardware with id '$id' found");
  }
}

@Riverpod(keepAlive: true)
FutureOr<List<VideoGameHardware>> sortedHardwareByPlatform(
  Ref ref,
  GamePlatform platform,
) async {
  final hardware = await ref.watch(hardwareByPlatformProvider(platform).future);

  return await ref.watch(applyHardwareSortingProvider(hardware).future);
}
