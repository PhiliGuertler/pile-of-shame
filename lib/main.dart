import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/initializer.dart';
import 'package:pile_of_shame/receive_share_app.dart';

void main() async {
  final providerContainer = ProviderContainer();

  final Initializer initializer = Initializer();
  initializer.setupInitialization();

  await initializer.initializeApp(providerContainer);

  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const ReceiveShareApp(),
    ),
  );
}
