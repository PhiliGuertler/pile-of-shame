import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:pile_of_shame/app.dart';
import 'package:pile_of_shame/providers/shared_content_provider.dart';

class ReceiveShareApp extends ConsumerStatefulWidget {
  const ReceiveShareApp({super.key});

  @override
  ConsumerState<ReceiveShareApp> createState() => _ReceiveShareAppState();
}

class _ReceiveShareAppState extends ConsumerState<ReceiveShareApp> {
  late StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
// For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        FlutterSharingIntent.instance.getMediaStream().listen(
      (List<SharedFile> value) {
        ref.read(sharedContentProvider.notifier).setFiles(value);
      },
      onError: (err) {
        throw Exception("Reading shared data failed");
      },
    );

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance
        .getInitialSharing()
        .then((List<SharedFile> value) {
      ref.read(sharedContentProvider.notifier).setFiles(value);
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
