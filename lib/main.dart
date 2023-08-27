import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/app.dart';
import 'package:pile_of_shame/initializer.dart';

void main() async {
  final providerContainer = ProviderContainer();

  final Initializer initializer = Initializer();
  initializer.setupInitialization();

  await initializer.initializeApp();

  runApp(UncontrolledProviderScope(
    container: providerContainer,
    child: const App(),
  ));
}
