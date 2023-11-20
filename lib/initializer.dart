import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/app.dart';
import 'package:pile_of_shame/providers/debug_provider.dart';

class Initializer {
  void setupInitialization() {
    final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: binding);
  }

  void _setupAutomaticErrorDisplay(ProviderContainer container) {
    // as there is no Buildcontext yet, we cannot access translations here.
    const String unknownErrorMessage = "Unknown Error";

    final originalError = FlutterError.onError;
    FlutterError.onError = (details) {
      final isDebugMode = container.read(debugFeatureAccessProvider);

      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade800,
            content: Text(
              isDebugMode
                  ? details.summary.toDescription()
                  : unknownErrorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      });
      originalError?.call(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      final isDebugMode = container.read(debugFeatureAccessProvider);

      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade800,
            content: Text(
              isDebugMode ? error.toString() : unknownErrorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      });
      return false;
    };
  }

  Future<void> initializeApp(ProviderContainer container) async {
    final isDebugMode = container.read(debugFeatureAccessProvider);
    if (isDebugMode) {
      Animate.restartOnHotReload = true;
    }

    _setupAutomaticErrorDisplay(container);

    FlutterNativeSplash.remove();
  }
}
