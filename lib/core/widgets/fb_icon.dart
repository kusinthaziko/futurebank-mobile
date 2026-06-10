import 'package:flutter/material.dart';

/// Phosphor icon wrapper with consistent 22px sizing and optional brand badge.
class FbIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final bool filled;

  const FbIcon({
    super.key,
    required this.icon,
    this.size = 22,
    this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color);
  }
}
