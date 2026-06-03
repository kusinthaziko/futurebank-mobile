import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class LoanDetailScreen extends StatelessWidget {
  final String loanId;
  const LoanDetailScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(r'''
          query LoanDetail($loanId: ID!) {
            loanApplication(id: $loanId) {
              id status amount_requested amount_approved purpose
              repayment_period_weeks interest_rate ai_risk_summary
              blockchain_contract_hash submitted_at decided_at disbursed_at
            }
            repaymentSchedule(loanId: $loanId) {
              id instalment_number due_date amount_due amount_paid status
            }
          }
        '''),
        variables: {'loanId': loanId},
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final loan = result.data?['loanApplication'] as Map<String, dynamic>? ?? {};
        final schedule = (result.data?['repaymentSchedule'] as List? ?? []).cast<Map<String, dynamic>>();

        return Scaffold(
          appBar: AppBar(title: const Text('Loan Details')),
          body: ListView(
            padding: const EdgeInsets.all(sp16),
            children: [
              // Status stepper
              _LoanStepper(status: loan['status'] ?? 'draft'),
              const SizedBox(height: sp20),
              // Details card
              FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _DetailRow('Amount', 'MWK ${loan['amount_approved'] ?? loan['amount_requested']}'),
                _DetailRow('Purpose', '${loan['purpose']}'),
                _DetailRow('Period', '${loan['repayment_period_weeks']} weeks'),
                _DetailRow('Rate', '${loan['interest_rate']}% per week'),
                if (loan['ai_risk_summary'] != null)
                  _DetailRow('AI Assessment', '${loan['ai_risk_summary']}'),
              ])),
              // Blockchain contract
              if (loan['blockchain_contract_hash'] != null) ...[
                const SizedBox(height: sp12),
                FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Blockchain Contract', style: AppTextStyles.labelLarge),
                  const SizedBox(height: sp4),
                  SelectableText('${loan['blockchain_contract_hash']}',
                      style: AppTextStyles.caption.copyWith(color: primary500)),
                  const SizedBox(height: sp4),
                  Text('What is this?',
                      style: AppTextStyles.caption.copyWith(
                          color: gray500, decoration: TextDecoration.underline)),
                ])),
              ],
              // Repayment schedule
              if (schedule.isNotEmpty) ...[
                const SizedBox(height: sp20),
                Text('Repayment Schedule', style: AppTextStyles.titleMedium),
                const SizedBox(height: sp8),
                ...schedule.map((s) => _ScheduleRow(instalment: s)),
              ],
              if (loan['status'] == 'active') ...[
                const SizedBox(height: sp24),
                FBButton(
                  label: 'Make Repayment',
                  onPressed: () => context.push('/loans/$loanId/repay'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _LoanStepper extends StatelessWidget {
  final String status;
  const _LoanStepper({required this.status});

  static const _steps = [
    'submitted', 'under_review', 'approved', 'disbursed', 'active', 'closed'
  ];

  int get _currentIndex => _steps.indexOf(status).clamp(0, _steps.length - 1);

  @override
  Widget build(BuildContext context) {
    return Column(children: List.generate(_steps.length, (i) {
      final done = i <= _currentIndex;
      final isCurrent = i == _currentIndex;
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              color: done ? primary500 : gray100,
              shape: BoxShape.circle,
              border: Border.all(color: done ? primary500 : gray300)),
            child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
          if (i < _steps.length - 1)
            Container(width: 2, height: 28, color: done ? primary500 : gray100),
        ]),
        const SizedBox(width: sp12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(_steps[i].replaceAll('_', ' ').toUpperCase(),
              style: AppTextStyles.labelMedium.copyWith(
                  color: isCurrent ? primary500 : done ? gray700 : gray300)),
        ),
      ]);
    }));
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: sp4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTextStyles.caption.copyWith(color: gray500)),
      Flexible(child: Text(value, style: AppTextStyles.labelMedium, textAlign: TextAlign.right)),
    ]),
  );
}

class _ScheduleRow extends StatelessWidget {
  final Map<String, dynamic> instalment;
  const _ScheduleRow({required this.instalment});

  Color get _color => switch ('${instalment['status']}') {
    'paid' => success500, 'overdue' => error500, _ => gray500
  };

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: sp4),
    child: Row(children: [
      Text('#${instalment['instalment_number']}',
          style: AppTextStyles.labelMedium.copyWith(color: gray500)),
      const SizedBox(width: sp8),
      Expanded(child: Text('${instalment['due_date']}', style: AppTextStyles.bodyMedium)),
      Text('MWK ${instalment['amount_due']}',
          style: AppTextStyles.labelMedium.copyWith(color: _color)),
    ]),
  );
}
