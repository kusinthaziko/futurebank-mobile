import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../domain/providers.dart';

class AiNudgeWidget extends ConsumerWidget {
  const AiNudgeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightAsync = ref.watch(aiInsightProvider);

    return insightAsync.when(
      loading: () => const FBSkeletonLoader(height: 64),
      error: (_, __) => const SizedBox.shrink(),
      data: (insight) {
        if (insight == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: sp16),
          child: GestureDetector(
            onTap: () => context.push('/coach'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FD),
                borderRadius: radius12,
                border: Border.all(color: const Color(0xFFB3D9F2)),
              ),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: primary100, borderRadius: radius8,
                  ),
                  child: const Icon(Icons.auto_awesome, color: primary500, size: 18),
                ),
                const SizedBox(width: sp12),
                Expanded(
                  child: Text(insight.message,
                      style: AppTextStyles.bodyMedium.copyWith(color: primary700)),
                ),
                const Icon(Icons.chevron_right, color: primary300, size: 18),
              ]),
            ),
          ),
        );
      },
    );
  }
}
