import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/graphql/client.dart';

class LoanApplyScreen extends ConsumerStatefulWidget {
  const LoanApplyScreen({super.key});
  @override
  ConsumerState<LoanApplyScreen> createState() => _LoanApplyScreenState();
}

class _LoanApplyScreenState extends ConsumerState<LoanApplyScreen> {
  int _step = 0;
  double _amount = 1000;
  String _purpose = 'Tuition';
  int _weeks = 4;
  bool _agreed = false;
  bool _loading = false;

  static const _purposes = ['Tuition', 'Books', 'Emergency', 'Business', 'Transport', 'Other'];
  static const _weekOptions = [2, 4, 8, 12];

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final token = ref.read(authProvider).accessToken;
      final client = ref.read(graphQLClientProvider(token));
      final result = await client.mutate(MutationOptions(
        document: gql(r'''
          mutation ApplyLoan($amount: Decimal!, $purpose: String!, $weeks: Int!) {
            applyForLoan(amount: $amount, purpose: $purpose, repayment_period_weeks: $weeks) {
              id status
            }
          }
        '''),
        variables: {
          'amount': _amount.toStringAsFixed(2),
          'purpose': _purpose,
          'weeks': _weeks,
        },
      ));
      if (!result.hasException && mounted) {
        context.go('/loans');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apply — Step ${_step + 1}/3')),
      body: Padding(
        padding: const EdgeInsets.all(sp24),
        child: Column(children: [
          Expanded(child: _buildStep()),
          const SizedBox(height: sp16),
          Row(children: [
            if (_step > 0) ...[
              Expanded(child: FBButton(
                label: 'Back',
                variant: FBButtonVariant.secondary,
                onPressed: () => setState(() => _step--),
              )),
              const SizedBox(width: sp12),
            ],
            Expanded(child: FBButton(
              label: _step == 2 ? 'Submit' : 'Next',
              onPressed: _step == 2 && !_agreed ? null : () {
                if (_step < 2) setState(() => _step++);
                else _submit();
              },
              loading: _loading,
            )),
          ]),
        ]),
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Loan Amount', style: AppTextStyles.titleLarge),
          const SizedBox(height: sp24),
          Text('MWK ${_amount.toStringAsFixed(0)}',
              style: AppTextStyles.displayMedium.copyWith(color: primary500)),
          Slider(
            value: _amount, min: 1000, max: 50000, divisions: 98,
            onChanged: (v) => setState(() => _amount = v),
          ),
          const SizedBox(height: sp24),
          Text('Purpose', style: AppTextStyles.labelLarge),
          const SizedBox(height: sp8),
          Wrap(spacing: sp8, children: _purposes.map((p) => ChoiceChip(
            label: Text(p), selected: _purpose == p,
            onSelected: (_) => setState(() => _purpose = p),
          )).toList()),
        ]),
      1 => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Repayment Period', style: AppTextStyles.titleLarge),
          const SizedBox(height: sp24),
          ..._weekOptions.map((w) => RadioListTile<int>(
            value: w, groupValue: _weeks,
            onChanged: (v) => setState(() => _weeks = v!),
            title: Text('$w weeks', style: AppTextStyles.bodyLarge),
            subtitle: Text(
              'MWK ${(_amount * 1.01 / w).toStringAsFixed(0)} / week',
              style: AppTextStyles.caption.copyWith(color: gray500)),
          )),
        ]),
      _ => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Review', style: AppTextStyles.titleLarge),
          const SizedBox(height: sp24),
          _ReviewRow('Amount', 'MWK ${_amount.toStringAsFixed(0)}'),
          _ReviewRow('Purpose', _purpose),
          _ReviewRow('Period', '$_weeks weeks'),
          _ReviewRow('Weekly payment',
              'MWK ${(_amount * 1.01 / _weeks).toStringAsFixed(0)}'),
          const SizedBox(height: sp24),
          CheckboxListTile(
            value: _agreed,
            onChanged: (v) => setState(() => _agreed = v!),
            title: const Text('I agree to the loan terms'),
            contentPadding: EdgeInsets.zero,
          ),
        ]),
    };
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReviewRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sp8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
          Text(value, style: AppTextStyles.labelLarge),
        ],
      ),
    );
  }
}
