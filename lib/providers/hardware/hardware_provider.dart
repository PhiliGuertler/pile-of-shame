import 'dart:convert';

import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/games/game_file_provider.dart';
import 'package:pile_of_shame/utils/data_migration.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hardware_provider.g.dart';

@riverpod
FutureOr<Map<GamePlatform, List<VideoGameHardware>>> hardware(
  HardwareRef ref,
) async {
  final gameFile = await ref.watch(gameFileProvider.future);

  final content = await gameFile.readAsString();

  if (content.isNotEmpty) {
    final Map<String, dynamic> jsonMap =
        jsonDecode(content) as Map<String, dynamic>;
    final games = GamesMigrator.loadAndMigrateGamesFromJson(jsonMap);
    return games.hardware.hardwareByPlatform;
  }
  return {};
}

@riverpod
FutureOr<List<GamePlatform>> hardwarePlatforms(
  HardwarePlatformsRef ref,
) async {
  final hardware = await ref.watch(hardwareProvider.future);

  final List<GamePlatform> result = [];
  for (final entry in hardware.entries) {
    if (entry.value.isNotEmpty) {
      result.add(entry.key);
    }
  }

  return result;
}

@riverpod
FutureOr<List<VideoGameHardware>> hardwareByPlatform(
  HardwareByPlatformRef ref,
  GamePlatform platform,
) async {
  final hardwareMap = await ref.watch(hardwareProvider.future);

  final content = hardwareMap[platform];
  return content ?? [];
}

@riverpod
FutureOr<double> hardwareTotalPrice(HardwareTotalPriceRef ref) async {
  final hardwareMap = await ref.watch(hardwareProvider.future);

  double sum = 0;
  for (final entry in hardwareMap.values) {
    sum += entry.fold(
      0.0,
      (previousValue, element) => element.price + previousValue,
    );
  }

  return sum;
}

@riverpod
FutureOr<double> hardwareTotalPriceByPlatform(
  HardwareTotalPriceByPlatformRef ref,
  GamePlatform platform,
) async {
  final hardwareMap = await ref.watch(hardwareProvider.future);

  final hardwareList = hardwareMap[platform] ?? [];

  return hardwareList.fold<double>(
    0.0,
    (previousValue, element) => element.price + previousValue,
  );
}
