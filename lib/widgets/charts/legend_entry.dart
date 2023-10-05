import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';

class LegendEntry extends StatefulWidget {
  const LegendEntry({
    super.key,
    required this.color,
    required this.text,
    required this.isSelected,
    this.size = 20,
    this.onTap,
  });
  final Color color;
  final String text;
  final bool isSelected;
  final double size;
  final VoidCallback? onTap;

  @override
  State<LegendEntry> createState() => _LegendEntryState();
}

class _LegendEntryState extends State<LegendEntry> {
  final GlobalKey _textKey = GlobalKey();
  Size? textSize;

  Size getTextSize(BuildContext context) {
    final box = context.findRenderObject()! as RenderBox;
    return box.size;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_textKey.currentContext != null) {
        setState(() {
          textSize = getTextSize(_textKey.currentContext!);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          AnimatedContainer(
            duration: 150.ms,
            curve: Curves.easeInOut,
            width: widget.isSelected
                ? (textSize?.width ?? widget.size)
                : widget.size,
            height: widget.isSelected
                ? (textSize?.height ?? widget.size)
                : widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: widget.color,
            ),
          ),
          Padding(
            key: _textKey,
            padding: EdgeInsets.only(left: widget.size + 4.0),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.size,
                fontWeight: FontWeight.bold,
                color: widget.isSelected
                    ? widget.color.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white
                    : null,
              ),
            ).animate(target: widget.isSelected ? 1 : 0).moveX(
                  begin: 0,
                  end: -widget.size * 0.5 - 2,
                  duration: 150.ms,
                  curve: Curves.easeInOut,
                ),
          ),
        ],
      ),
    );
  }
}

class LegendEntrySkeleton extends StatelessWidget {
  const LegendEntrySkeleton({super.key, this.textWidth = 55.0});

  final double textWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: SizedBox(
            width: 16,
            height: 16,
            child: Skeleton(
              height: 16,
              widthFactor: 1.0,
              borderRadius: 4.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16 * 1.5 + 4.0, right: 4.0),
          child: SizedBox(
            width: textWidth,
            child: const Skeleton(
              widthFactor: 1,
            ),
          ),
        ),
      ],
    );
  }
}
