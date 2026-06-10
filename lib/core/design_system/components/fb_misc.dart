import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/dimensions.dart';
import '../tokens/typography.dart';

class FBSkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const FBSkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });

  @override
  State<FBSkeletonLoader> createState() => _FBSkeletonLoaderState();
}

class _FBSkeletonLoaderState extends State<FBSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? radius8,
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: const [gray100, Color(0xFFE9ECEF), gray100],
          ),
        ),
      ),
    );
  }
}

class FBAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;

  const FBAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0] : '')
        .join()
        .toUpperCase();

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: primary100,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              initials,
              style: AppTextStyles.labelLarge.copyWith(color: primary500),
            )
          : null,
    );
  }
}
