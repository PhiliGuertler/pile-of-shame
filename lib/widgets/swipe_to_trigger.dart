import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

class SwipeToTrigger extends StatefulWidget {
  const SwipeToTrigger({
    required this.child,
    super.key,
    this.leftWidget,
    this.onTriggerLeft,
    this.rightWidget,
    this.onTriggerRight,
    this.triggerOffset = 0.5,
  });

  final double triggerOffset;
  final Widget child;
  final Widget Function(double triggerProgress)? leftWidget;
  final VoidCallback? onTriggerLeft;
  final Widget Function(double triggerProgress)? rightWidget;
  final VoidCallback? onTriggerRight;

  @override
  State<SwipeToTrigger> createState() => _SwipeToTriggerState();
}

class _SwipeToTriggerState extends State<SwipeToTrigger>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Offset _dragOffset = Offset.zero;
  bool isTriggerable = false;

  late Animation<Offset> _animation;

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      Tween<Offset>(
        begin: _dragOffset,
        end: Offset.zero,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecond = Offset(unitsPerSecondX, 0);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 40,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragOffset = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double progress =
        (_dragOffset.dx.abs() / size.width) / widget.triggerOffset;

    final Widget background = Stack(
      children: [
        if (widget.leftWidget != null && _dragOffset.dx > 1.0)
          BackgroundPane(
            height: size.height,
            width: _dragOffset.dx.abs(),
            alignment: Alignment.centerLeft,
            child: widget.leftWidget!(progress),
          ),
        if (widget.rightWidget != null && _dragOffset.dx < 1.0)
          BackgroundPane(
            height: size.height,
            width: _dragOffset.dx.abs(),
            alignment: Alignment.centerRight,
            child: widget.rightWidget!(progress),
          ),
        Transform.translate(
          offset: _dragOffset,
          child: widget.child,
        ),
      ],
    );

    return GestureDetector(
      onHorizontalDragStart: (details) {
        _controller.stop();
      },
      onHorizontalDragUpdate: (details) {
        double nextXValue = _dragOffset.dx + details.delta.dx;

        bool nextTriggerableState =
            (nextXValue.abs() / size.width) / widget.triggerOffset >= 1.0;

        if (nextXValue > 0 && widget.leftWidget == null ||
            nextXValue < 0 && widget.rightWidget == null) {
          nextXValue = 0;
          nextTriggerableState = false;
        }
        if (nextTriggerableState && !isTriggerable) {
          HapticFeedback.lightImpact();
        }
        setState(() {
          _dragOffset = Offset(nextXValue, 0);
          isTriggerable = nextTriggerableState;
        });
      },
      onHorizontalDragEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
        final signedProgress =
            (_dragOffset.dx / size.width) / widget.triggerOffset;
        if (signedProgress < -1.0 && widget.onTriggerRight != null) {
          widget.onTriggerRight!();
        }
        if (signedProgress > 1.0 && widget.onTriggerLeft != null) {
          widget.onTriggerLeft!();
        }
      },
      child: background,
    );
  }
}

class BackgroundPane extends StatelessWidget {
  const BackgroundPane({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.alignment,
  });

  final Widget child;
  final double width;
  final double height;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: ClipRect(
          child: SizedBox(
            height: height,
            width: width,
            child: child,
          ),
        ),
      ),
    );
  }
}
