import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;

  const ErrorDisplay({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.errorContainer,
      title: Text(
        error.toString(),
        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
      ),
      subtitle: Text(
        stackTrace.toString(),
        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
      ),
    );
  }
}
