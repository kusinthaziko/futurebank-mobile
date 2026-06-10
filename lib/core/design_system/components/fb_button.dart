import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/dimensions.dart';
import '../tokens/typography.dart';
import '../../widgets/animations/press_scale.dart';

enum FBButtonVariant { primary, secondary, ghost, destructive }

enum FBButtonSize { small, medium, large }

class FBButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FBButtonVariant variant;
  final FBButtonSize size;
  final bool loading;
  final Widget? icon;

  const FBButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = FBButtonVariant.primary,
    this.size = FBButtonSize.medium,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final height = switch (size) {
      FBButtonSize.small => 36.0,
      FBButtonSize.medium => 44.0,
      FBButtonSize.large => 52.0,
    };
    final (bg, fg, border) = switch (variant) {
      FBButtonVariant.primary => (primary500, white, null),
      FBButtonVariant.secondary => (primary100, primary500, null),
      FBButtonVariant.ghost => (Colors.transparent, primary500, primary300),
      FBButtonVariant.destructive => (error500, white, null),
    };

    return PressScale(
      onPressed: loading ? null : onPressed,
      haptic: onPressed != null ? 1 : 0,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: TextButton(
          onPressed: loading ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            shape: RoundedRectangleBorder(
              borderRadius: radiusPill,
              side: border != null
                  ? BorderSide(color: border)
                  : BorderSide.none,
            ),
            padding: const EdgeInsets.symmetric(horizontal: sp24),
          ),
          child: loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: fg),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: sp8)],
                    Text(
                      label,
                      style: AppTextStyles.labelLarge.copyWith(color: fg),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
