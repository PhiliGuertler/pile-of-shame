import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/widgets/popup_menu/stateful_popup_menu_item_controller.dart';
import 'package:uuid/uuid.dart';

import '../selected_text_style.dart';

class StatefulPopupMenuItem<T> extends PopupMenuEntry<T> {
  final VoidCallback onTap;
  final StatefulPopupMenuItemController<T> controller;
  final StatefulPopupMenuItemProps Function(T) onStateChanged;

  final T value;

  final String uuid;

  StatefulPopupMenuItem({
    super.key,
    required this.onTap,
    required this.controller,
    required this.onStateChanged,
    required this.value,
  }) : uuid = const Uuid().v4();

  @override
  State<StatefulWidget> createState() => StatefulPopupMenuItemState<T>();

  @override
  double get height =>
      (TextPainter(
        text: const TextSpan(
          text: 'Tq',
        ),
        maxLines: 1,
      )..layout())
          .height +
      16;

  @override
  bool represents(T? value) => true;
}

class StatefulPopupMenuItemState<T> extends State<StatefulPopupMenuItem<T>> {
  StatefulPopupMenuItemProps _props = StatefulPopupMenuItemProps(title: '');

  @override
  void initState() {
    super.initState();

    _props = widget.onStateChanged(widget.value);
  }

  @override
  void dispose() {
    widget.controller.removeListener(widget.uuid);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        widget.controller.addListener(widget.uuid, (value) {
          setState(
            () {
              _props = widget.onStateChanged(value);
            },
          );
        });
        return InkWell(
          onTap: widget.onTap,
          child: ListTile(
            leading: _props.leading,
            title: SelectedTextStyle(
              text: _props.title,
              isSelected: _props.isSelected,
            ),
          ),
        );
      },
    );
  }
}
