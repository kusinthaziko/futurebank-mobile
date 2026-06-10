import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/error_view.dart';
import '../../data/models/social_models.dart';
import '../../domain/providers.dart';

class GroupDetailScreen extends ConsumerWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(groupDetailProvider(groupId));
    return Scaffold(
      appBar: AppBar(title: const Text('Group')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.refresh(groupDetailProvider(groupId)),
        ),
        data: (group) => _GroupDetailBody(group: group, ref: ref),
      ),
    );
  }
}

class _GroupDetailBody extends ConsumerWidget {
  final GroupDetailModel group;
  final WidgetRef ref;

  const _GroupDetailBody({required this.group, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAmount = double.tryParse(group.goal ?? '') ?? 0;
    final poolAmount = double.tryParse(group.poolBalance) ?? 0;
    final progress = goalAmount > 0
        ? (poolAmount / goalAmount).clamp(0.0, 1.0)
        : 0.0;

    return ListView(
      padding: const EdgeInsets.all(sp16),
      children: [
        FBCard(
          gradient: true,
          child: Column(
            children: [
              Text(
                group.name,
                style: AppTextStyles.displayMedium.copyWith(color: white),
              ),
              const SizedBox(height: sp4),
              Text(
                '${group.groupType} · ${group.memberCount} members',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: sp12),
              Text(
                'MWK ${_formatAmount(group.poolBalance)} pooled',
                style: AppTextStyles.displayLarge.copyWith(color: gold300),
              ),
            ],
          ),
        ),
        const SizedBox(height: sp16),
        if (goalAmount > 0) ...[
          FBCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress to goal',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: sp8),
                ClipRRect(
                  borderRadius: radius4,
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: gray100,
                    valueColor: const AlwaysStoppedAnimation(primary500),
                  ),
                ),
                const SizedBox(height: sp4),
                Text(
                  'MWK ${_formatAmount(group.poolBalance)} / MWK ${_formatAmount(group.goal!)}  ${(progress * 100).toInt()}%',
                  style: AppTextStyles.caption.copyWith(color: gray500),
                ),
              ],
            ),
          ),
          const SizedBox(height: sp16),
        ],
        FBCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invite Code',
                style: AppTextStyles.labelMedium.copyWith(color: gray500),
              ),
              const SizedBox(height: sp8),
              if (group.inviteCode != null) ...[
                Center(
                  child: QrImageView(
                    data: group.inviteCode!,
                    size: 100,
                    eyeStyle: const QrEyeStyle(color: primary500),
                    dataModuleStyle: const QrDataModuleStyle(color: primary500),
                  ),
                ),
                const SizedBox(height: sp8),
              ],
              Row(
                children: [
                  Text(
                    group.inviteCode ?? '---',
                    style: AppTextStyles.titleLarge.copyWith(
                      letterSpacing: 4,
                      color: primary500,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy, color: primary500),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: group.inviteCode ?? ''),
                      );
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Copied!')));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: sp16),
        if (group.topContributors.isNotEmpty) ...[
          FBCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top Contributors',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: sp12),
                ...List.generate(group.topContributors.length, (i) {
                  final c = group.topContributors[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: sp4),
                    child: Row(
                      children: [
                        Text(
                          '${i + 1}.',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: gray500,
                          ),
                        ),
                        const SizedBox(width: sp8),
                        Expanded(
                          child: Text(
                            c.fullName,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        Text(
                          'MWK ${_formatAmount(c.totalContributed)}',
                          style: AppTextStyles.labelLarge,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: sp16),
        ],
        if (group.recentActivity.isNotEmpty) ...[
          FBCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recent Activity', style: AppTextStyles.titleMedium),
                const SizedBox(height: sp12),
                ...group.recentActivity.map(
                  (a) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: sp4),
                    child: Row(
                      children: [
                        const Icon(Icons.swap_horiz, size: 16, color: gray500),
                        const SizedBox(width: sp8),
                        Expanded(
                          child: Text(
                            '${a.fullName} ${a.action}${a.amount.isNotEmpty ? ' MWK ${_formatAmount(a.amount)}' : ''}',
                            style: AppTextStyles.caption.copyWith(
                              color: gray500,
                            ),
                          ),
                        ),
                        Text(
                          _timeAgo(a.createdAt),
                          style: AppTextStyles.caption.copyWith(color: gray300),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: sp16),
        ],
        FBButton(
          label: 'Contribute to Group',
          icon: const Icon(Icons.add),
          onPressed: () => _showContributeDialog(context, ref),
        ),
      ],
    );
  }

  void _showContributeDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Contribute'),
        content: FBInput(
          label: 'Amount (MWK)',
          hint: 'Enter amount',
          controller: ctrl,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FBButton(
            label: 'Confirm',
            onPressed: () async {
              final amount = ctrl.text.trim();
              if (amount.isEmpty) return;
              Navigator.pop(ctx);
              try {
                await ref
                    .read(
                      socialRepositoryProvider(ref.read(accessTokenProvider)),
                    )
                    .contributeToGroup(group.id, amount);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contribution successful!')),
                  );
                  ref.invalidate(groupDetailProvider(group.id));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  String _timeAgo(String dateStr) {
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _formatAmount(String amount) {
    final n = double.tryParse(amount) ?? 0;
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toStringAsFixed(0);
  }
}
