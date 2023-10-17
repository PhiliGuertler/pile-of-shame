import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/providers/hardware/hardware_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_provider.g.dart';

@riverpod
FutureOr<Database> databaseByPlatformFamily(
  DatabaseByPlatformFamilyRef ref,
  GamePlatformFamily? family,
) async {
  late List<Game> games;
  late List<VideoGameHardware> hardware;

  if (family != null) {
    games = await ref.watch(gamesByPlatformFamilyProvider(family).future);
    hardware = await ref.watch(hardwareByPlatformFamilyProvider(family).future);
  } else {
    games = await ref.watch(gamesProvider.future);
    hardware = await ref.watch(hardwareProvider.future);
  }

  return Database(games: games, hardware: hardware);
}
