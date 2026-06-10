import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/providers/security_provider.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/utils/validators.dart';
import '../../../../features/auth/domain/auth_state.dart';
import '../../domain/providers.dart';

Future<void> showMakeRepaymentSheet(
  BuildContext context, {
  required String loanId,
  required String nextAmount,
  required String walletBalance,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => MakeRepaymentSheet(
      loanId: loanId,
      nextAmount: nextAmount,
      walletBalance: walletBalance,
    ),
  );
}

class MakeRepaymentSheet extends ConsumerStatefulWidget {
  final String loanId;
  final String nextAmount;
  final String walletBalance;

  const MakeRepaymentSheet({
    super.key,
    required this.loanId,
    required this.nextAmount,
    required this.walletBalance,
  });

  @override
  ConsumerState<MakeRepaymentSheet> createState() => _MakeRepaymentSheetState();
}

class _MakeRepaymentSheetState extends ConsumerState<MakeRepaymentSheet> {
  late TextEditingController _amountCtrl;
  bool _loading = false;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(text: widget.nextAmount);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  double get _amountValue => double.tryParse(_amountCtrl.text) ?? 0;
  double get _balanceValue => double.tryParse(widget.walletBalance) ?? 0;
  double get _nextInstalmentValue => double.tryParse(widget.nextAmount) ?? 0;

  bool get _sufficient =>
      _amountValue > 0 &&
      _amountValue <= _balanceValue &&
      _amountValue <= _nextInstalmentValue;

  String? _validateRepaymentAmount() {
    if (_amountCtrl.text.isEmpty) return null;
    final err = validateAmount(_amountCtrl.text);
    if (err != null) return err;
    if (_amountValue > _nextInstalmentValue) {
      return 'Cannot exceed next instalment of MWK ${widget.nextAmount}';
    }
    if (_amountValue > _balanceValue) return 'Insufficient wallet balance';
    return null;
  }

  Future<void> _submit() async {
    if (!_sufficient) return;

    final bio = ref.read(biometricServiceProvider);
    final authenticated = await bio.authenticate('Authenticate to confirm repayment');
    if (!authenticated || !mounted) return;

    setState(() => _loading = true);
    try {
      final auth = ref.read(authProvider);
      final token = auth is Authenticated ? auth.accessToken : null;
      final repo = ref.read(loanRepositoryProvider(token));
      await repo.makeRepayment(widget.loanId, _amountCtrl.text);
      setState(() => _success = true);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Repayment successful!'),
            backgroundColor: success500,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Repayment failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        sp24,
        sp16,
        sp24,
        MediaQuery.of(context).viewInsets.bottom + sp16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: sp20),
          const Text('Make Repayment', style: AppTextStyles.titleLarge),
          const SizedBox(height: sp24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Wallet Balance',
                  style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
              Text('MWK ${widget.walletBalance}',
                  style: AppTextStyles.labelLarge.copyWith(color: success500)),
            ],
          ),
          const SizedBox(height: sp16),
          FBInput(
            label: 'Amount (MWK)',
            hint: 'Enter repayment amount',
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            error: _validateRepaymentAmount(),
            onChanged: (_) => setState(() {}),
            suffix: TextButton(
              onPressed: () {
                _amountCtrl.text = widget.nextAmount;
                setState(() {});
              },
              child: const Text('Full'),
            ),
          ),
          const SizedBox(height: sp8),
          Text(
            'Next instalment: MWK ${widget.nextAmount}',
            style: AppTextStyles.caption.copyWith(color: gray500),
          ),
          const SizedBox(height: sp24),
          FBButton(
            label: _success ? 'Repayment Complete!' : 'Confirm Repayment',
            onPressed: _sufficient && !_loading ? _submit : null,
            loading: _loading,
          ),
          const SizedBox(height: sp8),
        ],
      ),
    );
  }
}
