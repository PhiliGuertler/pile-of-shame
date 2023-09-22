import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

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

  Offset _dragOffset = const Offset(0, 0);

  late Animation<Offset> _animation;

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      Tween<Offset>(
        begin: _dragOffset,
        end: const Offset(0, 0),
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
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

    Widget background = Stack(
      fit: StackFit.expand,
      children: [
        if (widget.leftWidget != null && _dragOffset.dx > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: double.infinity,
              width: _dragOffset.dx.abs(),
              child: widget.leftWidget!(progress),
            ),
          ),
        if (widget.rightWidget != null && _dragOffset.dx < 0)
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: double.infinity,
              width: _dragOffset.dx.abs(),
              child: widget.rightWidget!(progress),
            ),
          ),
        Transform.translate(
          offset: _dragOffset,
          child: widget.child,
        ),
      ],
    );

    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        final nextXValue = _dragOffset.dx + details.delta.dx;
        if (nextXValue > 0 && widget.leftWidget == null ||
            nextXValue < 0 && widget.rightWidget == null) {
          setState(() {
            _dragOffset = const Offset(0, 0);
          });
        } else {
          setState(() {
            _dragOffset = Offset(nextXValue, 0);
          });
        }
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
        if (progress < -1.0 && widget.onTriggerRight != null) {
          widget.onTriggerRight!();
        }
        if (progress > 1.0 && widget.onTriggerLeft != null) {
          widget.onTriggerLeft!();
        }
      },
      child: background,
    );
  }
}
