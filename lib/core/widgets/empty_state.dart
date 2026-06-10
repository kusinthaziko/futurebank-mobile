// Single responsibility: reusable empty / error state placeholder
import 'package:flutter/material.dart';
import '../design_system/tokens/dimensions.dart';
import '../design_system/tokens/typography.dart';

/// A centered empty-state placeholder with icon, title, optional subtitle,
/// and an optional action widget.
///
/// Designed to be used inside a `SliverFillRemaining`, `Center`, or column
/// whenever a list or section has no data to display.
class FbEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const FbEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(sp32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: cs.outline),
            const SizedBox(height: sp16),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: sp8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: sp24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
