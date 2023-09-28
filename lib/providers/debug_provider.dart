import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_provider.g.dart';

@Riverpod(keepAlive: true)
class DebugFeatureAccess extends _$DebugFeatureAccess {
  @override
  bool build() {
    return kDebugMode;
  }

  bool toggleDebugMode() {
    // ignore: join_return_with_assignment
    state = !state;
    return state;
  }
}
