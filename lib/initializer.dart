import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class Initializer {
  void setupInitialization() {
    WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: binding);
  }

  Future<void> initializeApp() async {
    // TODO: Do some async initialization here
    if (kDebugMode) {
      Animate.restartOnHotReload = true;
    }

    FlutterNativeSplash.remove();
  }
}
