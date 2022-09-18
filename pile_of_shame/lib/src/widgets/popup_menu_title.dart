import 'package:flutter/material.dart';

class PopupMenuTitle<T> extends PopupMenuEntry<T> {
  final String title;
  final TextOverflow overflow;

  /// Creates the menu entry widget.
  ///
  /// Specify the title to display with [title].
  /// Specify the text overflow style with [overflow].
  /// Specify a custom [TextStyle] with [textStyle]. The [defaultFontWeight] and
  /// primary theme color will be used by default.
  const PopupMenuTitle({
    super.key,
    required this.title,
    this.overflow = TextOverflow.ellipsis,
  });

  /// Constructs a [TextPainter] and uses the calculated [TextPainter.height]
  /// with the [defaultPadding] to calculate the height of the widget.
  @override
  double get height => (TextPainter(
        text: TextSpan(
          text: title,
        ),
        maxLines: 1,
      )..layout())
          .height;

  /// This menu entry isn't selectable; it represents no value.
  /// Always returns false.
  @override
  bool represents(void value) => false;

  @override
  _PopupMenuTitleState createState() => _PopupMenuTitleState();
}

class _PopupMenuTitleState extends State<PopupMenuTitle> {
  @override
  Widget build(BuildContext context) {
    assert(
      Theme.of(context) != null,
      'Cannot find theme! Specify a custom TextStyle.',
    );

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Text(
        widget.title,
        overflow: widget.overflow,
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
        ),
      ),
    );
  }
}
