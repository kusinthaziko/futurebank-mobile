import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../domain/providers.dart';

class ReportsTab extends ConsumerWidget {
  const ReportsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(adminReportsProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: Text('Could not load reports',
            style: AppTextStyles.bodyMedium.copyWith(color: gray500))),
      data: (reports) {
        final totalSavings = reports['totalSavings'] as String? ?? '0';
        final activeLoanCount = reports['activeLoanCount'] as int? ?? 0;
        final activeLoanValue = reports['activeLoanValue'] as String? ?? '0';
        final defaultRate = (reports['defaultRate'] as num?)?.toDouble() ?? 0.0;
        final kycDist = (reports['kycLevelDistribution'] as List?)
            ?.cast<Map<String, dynamic>>() ?? [];

        return ListView(
          padding: const EdgeInsets.all(sp16),
          children: [
            _StatCard(
              icon: Icons.savings,
              title: 'Total Savings',
              value: 'MWK ${_formatAmount(totalSavings)}',
              color: primary500,
            ),
            const SizedBox(height: sp12),
            _StatCard(
              icon: Icons.credit_score,
              title: 'Active Loans',
              value: '$activeLoanCount loans · MWK ${_formatAmount(activeLoanValue)}',
              color: gold500,
            ),
            const SizedBox(height: sp12),
            _StatCard(
              icon: Icons.warning_amber,
              title: 'Default Rate',
              value: '${(defaultRate * 100).toStringAsFixed(1)}%',
              color: defaultRate > 0.1 ? error500 : success500,
            ),
            const SizedBox(height: sp16),
            FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('KYC Level Distribution',
                  style: AppTextStyles.titleMedium),
              const SizedBox(height: sp12),
              ...kycDist.map((d) => Padding(
                padding: const EdgeInsets.symmetric(vertical: sp4),
                child: Row(children: [
                  Text('Level ${d['level']}',
                      style: AppTextStyles.bodyMedium),
                  const Spacer(),
                  Text('${d['count']} students',
                      style: AppTextStyles.labelLarge),
                ]),
              )),
            ])),
            const SizedBox(height: sp24),
            FBButton(
              label: 'Export CSV',
              variant: FBButtonVariant.secondary,
              icon: const Icon(Icons.download),
              onPressed: () => _exportCsv(context, reports),
            ),
          ],
        );
      },
    );
  }

  void _exportCsv(BuildContext context, Map<String, dynamic> reports) {
    final buffer = StringBuffer();
    buffer.writeln('Metric,Value');
    buffer.writeln('Total Savings,${reports['totalSavings']}');
    buffer.writeln('Active Loan Count,${reports['activeLoanCount']}');
    buffer.writeln('Active Loan Value,${reports['activeLoanValue']}');
    buffer.writeln('Default Rate,${reports['defaultRate']}');

    final kycDist = (reports['kycLevelDistribution'] as List?)
        ?.cast<Map<String, dynamic>>() ?? [];
    for (final d in kycDist) {
      buffer.writeln('KYC Level ${d['level']},${d['count']}');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV copied to clipboard')));
  }

  String _formatAmount(String amount) {
    final n = double.tryParse(amount) ?? 0;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toStringAsFixed(0);
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon, required this.title,
    required this.value, required this.color,
  });

  @override
  Widget build(BuildContext context) => FBCard(
    child: Row(children: [
      Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1), borderRadius: radius12),
        child: Icon(icon, color: color, size: 22),
      ),
      const SizedBox(width: sp12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.caption.copyWith(color: gray500)),
        Text(value, style: AppTextStyles.titleMedium),
      ])),
    ]),
  );
}
