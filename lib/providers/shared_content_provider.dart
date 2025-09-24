// ignore_for_file: use_setters_to_change_properties

import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_content_provider.g.dart';

@Riverpod(keepAlive: true)
class SharedContent extends _$SharedContent {
  @override
  List<SharedFile> build() {
    return [];
  }

  void setFiles(List<SharedFile> files) {
    state = files;
  }
}

@Riverpod(keepAlive: true)
bool hasSharedContent(Ref ref) {
  final content = ref.watch(sharedContentProvider);
  return content.isNotEmpty;
}
