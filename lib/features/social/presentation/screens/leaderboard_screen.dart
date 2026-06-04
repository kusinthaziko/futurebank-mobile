import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/error_view.dart';
import '../../data/models/social_models.dart';
import '../../domain/providers.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String _period = 'all_time';
  final _periods = [
    ('this_week', 'This Week'),
    ('this_month', 'This Month'),
    ('all_time', 'All Time'),
  ];

  @override
  Widget build(BuildContext context) {
    final institutionId = ref.watch(institutionIdProvider) ?? '';
    final async = ref.watch(leaderboardListProvider((institutionId: institutionId, period: _period)));
    final userId = ref.watch(userIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
          child: Row(children: _periods.map((p) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: sp4),
              child: GestureDetector(
                onTap: () => setState(() => _period = p.$1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: sp10),
                  decoration: BoxDecoration(
                    color: _period == p.$1 ? primary500 : gray100,
                    borderRadius: radiusPill,
                  ),
                  child: Text(p.$2, textAlign: TextAlign.center,
                      style: AppTextStyles.labelMedium.copyWith(
                          color: _period == p.$1 ? white : gray700)),
                ),
              ),
            ),
          )).toList()),
        ),
        Expanded(
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => ErrorView(error: e, onRetry: () => ref.refresh(
                leaderboardListProvider((institutionId: institutionId, period: _period)))),
            data: (entries) {
              final sorted = List<LeaderboardEntry>.from(entries)
                ..sort((a, b) => a.rank.compareTo(b.rank));
              final top3 = sorted.where((e) => e.rank <= 3).toList();
              final myEntry = sorted.where((e) => e.userId == userId).firstOrNull;
              final others = sorted.where((e) => e.rank > 3 && e.userId != userId).toList();

              return ListView(
                padding: const EdgeInsets.all(sp16),
                children: [
                  if (top3.isNotEmpty) ...[
                    _Podium(top3: top3),
                    const SizedBox(height: sp16),
                  ],
                  ...top3.map((e) => _LeaderboardTile(entry: e, isMe: e.userId == userId)),
                  if (others.isNotEmpty) ...[
                    const Divider(height: sp32),
                    ...others.map((e) => _LeaderboardTile(entry: e, isMe: false)),
                  ],
                  if (myEntry != null && myEntry.rank > 3) ...[
                    const SizedBox(height: sp8),
                    _LeaderboardTile(entry: myEntry, isMe: true, highlight: true),
                  ],
                  if (sorted.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(sp32),
                      child: Column(children: [
                        const Icon(Icons.leaderboard_outlined, size: 64, color: gray300),
                        const SizedBox(height: sp16),
                        Text('No rankings yet',
                            style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
                      ]),
                    ),
                ],
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _Podium extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  const _Podium({required this.top3});

  @override
  Widget build(BuildContext context) {
    final order = top3.length >= 3
        ? [top3[1], top3[0], top3[2]]
        : top3;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(order.length, (i) {
        final entry = order[i];
        final height = [80.0, 100.0, 60.0][i];
        final medal = ['🥈', '🥇', '🥉'][i];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: sp8),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(medal, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: sp4),
            Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(
                color: primary100, shape: BoxShape.circle),
              child: Center(
                child: Text(entry.fullName.isNotEmpty ? entry.fullName[0] : '?',
                    style: AppTextStyles.labelLarge.copyWith(color: primary500)),
              ),
            ),
            const SizedBox(height: sp4),
            Text(entry.fullName.split(' ').first,
                style: AppTextStyles.caption, textAlign: TextAlign.center),
            Text('${entry.score}', style: AppTextStyles.labelMedium),
            const SizedBox(height: sp8),
            Container(
              width: 40, height: height,
              decoration: BoxDecoration(
                color: [gold100, primary100, gray100][i],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ),
          ]),
        );
      }),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isMe;
  final bool highlight;
  const _LeaderboardTile({required this.entry, this.isMe = false, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    final firstName = entry.fullName.split(' ').first;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sp4),
      child: Container(
        padding: const EdgeInsets.all(sp12),
        decoration: BoxDecoration(
          color: highlight ? primary100 : cardColor,
          borderRadius: radius12,
          border: highlight ? Border.all(color: primary500) : null,
        ),
        child: Row(children: [
          SizedBox(
            width: 24,
            child: Text('${entry.rank}.',
                style: AppTextStyles.labelLarge.copyWith(color: gray500)),
          ),
          const SizedBox(width: sp8),
          FBAvatarSmall(name: entry.fullName),
          const SizedBox(width: sp12),
          Expanded(
            child: Text(firstName,
                style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isMe ? FontWeight.w600 : null)),
          ),
          Text('${entry.score} pts',
              style: AppTextStyles.labelLarge.copyWith(color: primary500)),
        ]),
      ),
    );
  }
}

class FBAvatarSmall extends StatelessWidget {
  final String name;
  const FBAvatarSmall({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.split(' ').take(2).map((w) => w.isNotEmpty ? w[0] : '').join();
    return CircleAvatar(
      radius: 16,
      backgroundColor: primary100,
      child: Text(initials,
          style: AppTextStyles.labelMedium.copyWith(color: primary500)),
    );
  }
}
