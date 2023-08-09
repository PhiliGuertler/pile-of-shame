import 'package:flutter/material.dart';
import 'package:pile_of_shame/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  final providerContainer = ProviderContainer();

  runApp(UncontrolledProviderScope(
    container: providerContainer,
    child: const App(),
  ));
}
