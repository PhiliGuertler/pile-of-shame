import 'package:flutter/material.dart';

class StatefulPopupMenuItemController<T> {
  Map<String, void Function(T)> listeners;

  StatefulPopupMenuItemController({
    Map<String, Function(T)>? listeners,
  }) : listeners = listeners ?? {};

  void addListener(String id, Function(T) callback) {
    listeners[id] = callback;
  }

  void removeListener(String id) {
    listeners.remove(id);
  }

  void notifyAll(T value) {
    listeners.forEach((id, callback) {
      callback(value);
    });
  }
}

class StatefulPopupMenuItemProps {
  final String title;
  final bool isSelected;
  final Widget? leading;

  StatefulPopupMenuItemProps({
    required this.title,
    this.isSelected = false,
    this.leading,
  });
}
