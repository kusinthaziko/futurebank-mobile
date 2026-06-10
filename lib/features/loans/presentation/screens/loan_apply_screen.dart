import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../features/auth/domain/auth_state.dart';
import '../../domain/providers.dart';

class LoanApplyScreen extends ConsumerStatefulWidget {
  const LoanApplyScreen({super.key});
  @override
  ConsumerState<LoanApplyScreen> createState() => _LoanApplyScreenState();
}

class _LoanApplyScreenState extends ConsumerState<LoanApplyScreen> {
  int _step = 0;
  double _amount = 5000;
  String _purpose = 'Tuition';
  String _customDescription = '';
  int _weeks = 4;
  bool _agreed = false;
  bool _loading = false;

  static const _purposes = [
    'Tuition', 'Books', 'Emergency', 'Business', 'Transport', 'Other',
  ];
  static const _weekOptions = [2, 4, 8, 12];

  double get _interestRate => 0.01;
  double get _totalRepayment => _amount * (1 + _interestRate * _weeks);
  double get _weeklyAmount => _totalRepayment / _weeks;
  double get _totalInterest => _totalRepayment - _amount;

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final auth = ref.read(authProvider);
      final token = auth is Authenticated ? auth.accessToken : null;
      final repo = ref.read(loanRepositoryProvider(token));
      await repo.applyForLoan(
        amount: _amount.toStringAsFixed(2),
        purpose: _purpose == 'Other' ? _customDescription : _purpose,
        weeks: _weeks,
      );
      ref.invalidate(loansProvider);
      if (mounted) context.go('/loans');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _canProceed => switch (_step) {
    0 => true,
    1 => true,
    _ => _agreed,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apply — Step ${_step + 1}/3')),
      body: Padding(
        padding: const EdgeInsets.all(sp24),
        child: Column(children: [
          _buildStepper(),
          const SizedBox(height: sp20),
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
              label: _step == 2 ? 'Submit Application' : 'Next',
              onPressed: !_canProceed
                  ? null
                  : () {
                      if (_step < 2) {
                        setState(() => _step++);
                      } else {
                        _submit();
                      }
                    },
              loading: _loading,
            )),
          ]),
        ]),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(children: List.generate(3, (i) {
      final done = i <= _step;
      return Expanded(
        child: Row(children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: done ? primary500 : gray100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('${i + 1}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: done ? white : gray500,
                  )),
            ),
          ),
          if (i < 2)
            Expanded(
              child: Container(
                height: 2,
                color: i < _step ? primary500 : gray300,
              ),
            ),
        ]),
      );
    }));
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => _buildStep1(),
      1 => _buildStep2(),
      _ => _buildStep3(),
    };
  }

  Widget _buildStep1() {
    return ListView(children: [
      const Text('Loan Details', style: AppTextStyles.titleLarge),
      const SizedBox(height: sp24),
      Text('Amount: MWK ${_amount.toStringAsFixed(0)}',
          style: AppTextStyles.displayMedium.copyWith(color: primary500)),
      Slider(
        value: _amount,
        min: 1000,
        max: 50000,
        divisions: 49,
        activeColor: primary500,
        onChanged: (v) => setState(() => _amount = v),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('MWK 1,000',
            style: AppTextStyles.caption.copyWith(color: gray500)),
        Text('MWK 50,000',
            style: AppTextStyles.caption.copyWith(color: gray500)),
      ]),
      const SizedBox(height: sp24),
      const Text('Purpose', style: AppTextStyles.labelLarge),
      const SizedBox(height: sp8),
      Wrap(
        spacing: sp8,
        runSpacing: sp8,
        children: _purposes.map((p) {
          final sel = _purpose == p;
          return ChoiceChip(
            label: Text(p),
            selected: sel,
            selectedColor: primary500,
            labelStyle: TextStyle(
              color: sel ? white : gray700,
              fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
            ),
            onSelected: (_) => setState(() => _purpose = p),
          );
        }).toList(),
      ),
      if (_purpose == 'Other') ...[
        const SizedBox(height: sp16),
        FBInput(
          label: 'Describe purpose',
          hint: 'Enter details...',
          error: _customDescription.length > 200
              ? 'Maximum 200 characters'
              : null,
          onChanged: (v) => _customDescription = v,
        ),
      ],
    ]);
  }

  Widget _buildStep2() {
    return ListView(children: [
      const Text('Repayment Plan', style: AppTextStyles.titleLarge),
      const SizedBox(height: sp8),
      Text(
        'Interest: ${(_interestRate * 100).toStringAsFixed(0)}% / week',
        style: AppTextStyles.bodyMedium.copyWith(color: gray500),
      ),
      const SizedBox(height: sp20),
      const Text('Repayment Period', style: AppTextStyles.labelLarge),
      const SizedBox(height: sp8),
      Wrap(
        spacing: sp8,
        children: _weekOptions.map((w) {
          final sel = _weeks == w;
          return ChoiceChip(
            label: Text('$w weeks'),
            selected: sel,
            selectedColor: primary500,
            labelStyle: TextStyle(
              color: sel ? white : gray700,
              fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
            ),
            onSelected: (_) => setState(() => _weeks = w),
          );
        }).toList(),
      ),
      const SizedBox(height: sp24),
      FBCard(
        child: Column(children: [
          _row('Weekly Amount', 'MWK ${_weeklyAmount.toStringAsFixed(0)}'),
          const SizedBox(height: sp4),
          _row('Total Repayment', 'MWK ${_totalRepayment.toStringAsFixed(0)}'),
          const SizedBox(height: sp4),
          _row('Total Interest', 'MWK ${_totalInterest.toStringAsFixed(0)}'),
          const SizedBox(height: sp4),
          _row('Interest Rate', '${(_interestRate * 100).toStringAsFixed(0)}% / week'),
        ]),
      ),
    ]);
  }

  Widget _buildStep3() {
    return ListView(children: [
      const Text('Review & Submit', style: AppTextStyles.titleLarge),
      const SizedBox(height: sp20),
      FBCard(
        child: Column(children: [
          _row('Amount', 'MWK ${_amount.toStringAsFixed(0)}'),
          _row('Purpose', _purpose),
          _row('Period', '$_weeks weeks'),
          _row('Weekly Payment', 'MWK ${_weeklyAmount.toStringAsFixed(0)}'),
          _row('Total Payable', 'MWK ${_totalRepayment.toStringAsFixed(0)}'),
          _row('Interest', 'MWK ${_totalInterest.toStringAsFixed(0)}'),
        ]),
      ),
      const SizedBox(height: sp16),
      Container(
        padding: const EdgeInsets.all(sp12),
        decoration: BoxDecoration(
          color: primary100,
          borderRadius: radius12,
        ),
        child: Row(children: [
          const Icon(Icons.auto_awesome, color: primary500, size: 18),
          const SizedBox(width: sp8),
          Text(
            'AI is analyzing your profile...',
            style: AppTextStyles.labelMedium.copyWith(color: primary500),
          ),
        ]),
      ),
      const SizedBox(height: sp16),
      CheckboxListTile(
        value: _agreed,
        onChanged: (v) => setState(() => _agreed = v!),
        title: const Text(
          'I agree to the loan terms',
          style: AppTextStyles.bodyMedium,
        ),
        subtitle: Text(
          'Repayment of MWK ${_weeklyAmount.toStringAsFixed(0)} weekly for $_weeks weeks',
          style: AppTextStyles.caption.copyWith(color: gray500),
        ),
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    ]);
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sp4),
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
