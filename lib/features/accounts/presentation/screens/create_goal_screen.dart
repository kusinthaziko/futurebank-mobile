import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/icons.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/graphql/client.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../features/auth/domain/auth_state.dart';
import '../../../accounts/domain/providers.dart';
import '../../data/graphql/queries.dart';

final _categories = ['Tuition', 'Emergency', 'Business', 'Personal', 'Group'];

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});
  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  String _category = 'Personal';
  DateTime? _deadline;
  bool _loading = false;
  String? _error;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Enter a goal name');
      return;
    }
    final target = _targetCtrl.text.trim();
    if (target.isEmpty ||
        double.tryParse(target) == null ||
        double.parse(target) <= 0) {
      setState(() => _error = 'Enter a valid target amount');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final a = ref.read(authProvider);
      final t = a is Authenticated ? a.accessToken : null;
      final client = ref.read(graphQLClientProvider(t));
      final data = await ref.read(accountsProvider.future);
      if (data.accounts.isEmpty) {
        if (mounted) {
          setState(() => _error = 'No account available for this goal.');
        }
        return;
      }
      final accountId = data.accounts
          .firstWhere(
            (a) => a.accountType == 'savings',
            orElse: () => data.accounts.first,
          )
          .id;
      final r = await client.mutate(
        MutationOptions(
          document: gql(createSavingsGoalMutation),
          variables: {
            'input': {
              'account_id': accountId,
              'name': name,
              'target_amount': target,
              'category': _category,
              if (_deadline != null) 'deadline': _deadline!.toIso8601String(),
            },
          },
        ),
      );
      if (r.hasException) throw r.exception!;
      ref.invalidate(accountsProvider);
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _error = ErrorView.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Savings Goal')),
      body: Padding(
        padding: const EdgeInsets.all(sp24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FBInput(
              label: 'Goal Name',
              hint: 'e.g. New Laptop',
              controller: _nameCtrl,
            ),
            const SizedBox(height: sp16),
            FBInput(
              label: 'Target Amount (MWK)',
              hint: '500000',
              controller: _targetCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: sp20),
            Text(
              'Category',
              style: AppTextStyles.labelMedium.copyWith(color: gray700),
            ),
            const SizedBox(height: sp8),
            Wrap(
              spacing: sp8,
              runSpacing: sp8,
              children: _categories
                  .map(
                    (cat) => ChoiceChip(
                      label: Text(cat),
                      selected: _category == cat,
                      selectedColor: primary100,
                      labelStyle: AppTextStyles.labelMedium.copyWith(
                        color: _category == cat ? primary500 : gray700,
                      ),
                      onSelected: (_) => setState(() => _category = cat),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: sp20),
            Text(
              'Deadline',
              style: AppTextStyles.labelMedium.copyWith(color: gray700),
            ),
            const SizedBox(height: sp8),
            InkWell(
              onTap: _pickDate,
              borderRadius: radius12,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: sp16,
                  vertical: sp12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: gray300, width: 1.5),
                  borderRadius: radius12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _deadline != null
                          ? '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}'
                          : 'Select a date',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: _deadline != null ? gray900 : gray500,
                      ),
                    ),
                    const Icon(FbIcons.calendar, color: gray500, size: 18),
                  ],
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: sp8),
              Text(
                _error!,
                style: AppTextStyles.caption.copyWith(color: error500),
              ),
            ],
            const Spacer(),
            FBButton(
              label: 'Create Goal',
              onPressed: _create,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
