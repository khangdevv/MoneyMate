import 'package:flutter/material.dart';

class CategoryIconBadge extends StatelessWidget {
  final String emoji;
  final Color color;
  final double size;
  final double alpha;

  const CategoryIconBadge({
    super.key,
    required this.emoji,
    required this.color,
    this.size = 44,
    this.alpha = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(size * 0.27),
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}
