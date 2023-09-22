import 'package:flutter/material.dart';

class FeedbackContainer extends StatelessWidget {
  final Widget child;

  const FeedbackContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade700,
            blurRadius: 3,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Material(
          child: child,
        ),
      ),
    );
  }
}
