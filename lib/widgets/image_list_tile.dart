import 'package:flutter/material.dart';

class ImageListTile extends StatelessWidget {
  const ImageListTile({
    super.key,
    required this.imagePath,
    required this.heroTag,
    this.onTap,
    this.child,
  });

  final String imagePath;
  final String heroTag;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
