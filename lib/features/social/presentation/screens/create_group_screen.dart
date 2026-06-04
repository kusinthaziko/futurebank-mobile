import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../domain/providers.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _nameCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();
  final _rulesCtrl = TextEditingController();
  String _groupType = 'Savings Circle';
  double _memberLimit = 50;
  bool _isPublic = true;
  bool _hasGoal = false;
  bool _hasRules = false;
  DateTime? _deadline;
  bool _loading = false;

  final _types = ['Savings Circle', 'Class', 'Department'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _goalCtrl.dispose();
    _rulesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create Group')),
    body: ListView(
      padding: const EdgeInsets.all(sp16),
      children: [
        FBInput(label: 'Group Name', hint: 'e.g. CS 2026 Savings Circle',
            controller: _nameCtrl),
        const SizedBox(height: sp16),
        Text('Type', style: AppTextStyles.labelMedium.copyWith(color: gray700)),
        const SizedBox(height: sp8),
        Row(children: _types.map((t) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: sp4),
            child: GestureDetector(
              onTap: () => setState(() => _groupType = t),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: sp12),
                decoration: BoxDecoration(
                  color: _groupType == t ? primary500 : gray100,
                  borderRadius: radius12,
                ),
                child: Text(t, textAlign: TextAlign.center,
                    style: AppTextStyles.labelMedium.copyWith(
                        color: _groupType == t ? white : gray700)),
              ),
            ),
          ),
        )).toList()),
        const SizedBox(height: sp24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Member limit: ${_memberLimit.toInt()}',
              style: AppTextStyles.labelLarge),
        ]),
        Slider(
          value: _memberLimit,
          min: 10, max: 200, divisions: 19,
          label: '${_memberLimit.toInt()}',
          onChanged: (v) => setState(() => _memberLimit = v),
        ),
        const SizedBox(height: sp16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Public group'),
          subtitle: const Text('Anyone can find and join'),
          value: _isPublic,
          onChanged: (v) => setState(() => _isPublic = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Set savings target'),
          value: _hasGoal,
          onChanged: (v) => setState(() => _hasGoal = v),
        ),
        if (_hasGoal) ...[
          const SizedBox(height: sp8),
          FBInput(label: 'Target Amount (MWK)', hint: 'e.g. 50000',
              controller: _goalCtrl, keyboardType: TextInputType.number),
          const SizedBox(height: sp12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_deadline == null ? 'Set deadline' : 'Deadline: ${_deadline!.toLocal()}'.split(' ')[0]),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              );
              if (picked != null) setState(() => _deadline = picked);
            },
          ),
        ],
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Set group rules'),
          value: _hasRules,
          onChanged: (v) => setState(() => _hasRules = v),
        ),
        if (_hasRules) ...[
          const SizedBox(height: sp8),
          FBInput(label: 'Rules (e.g. min weekly contribution)',
              hint: 'e.g. Minimum MWK 500 per week', controller: _rulesCtrl),
        ],
        const SizedBox(height: sp32),
        FBButton(
          label: 'Create Group',
          loading: _loading,
          onPressed: _nameCtrl.text.trim().isEmpty ? null : _createGroup,
        ),
      ],
    ),
  );

  Future<void> _createGroup() async {
    setState(() => _loading = true);
    try {
      final token = ref.read(accessTokenProvider);
      final result = await ref.read(socialRepositoryProvider(token)).createGroup(
        name: _nameCtrl.text.trim(),
        groupType: _groupType,
        isPublic: _isPublic,
        memberLimit: _memberLimit.toInt(),
        goal: _hasGoal ? _goalCtrl.text.trim() : null,
        deadline: _deadline?.toIso8601String(),
        rules: _hasRules ? _rulesCtrl.text.trim() : null,
      );
      if (context.mounted) {
        _showSuccess(context, result.inviteCode, result.id);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSuccess(BuildContext context, String inviteCode, String groupId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Group Created!'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check_circle, color: success500, size: 48),
          const SizedBox(height: sp16),
          const Text('Invite Code:', style: AppTextStyles.labelMedium),
          const SizedBox(height: sp4),
          Text(inviteCode, style: AppTextStyles.displayMedium.copyWith(
              letterSpacing: 4, color: primary500)),
          const SizedBox(height: sp8),
          Text('Share this code with members',
              style: AppTextStyles.caption.copyWith(color: gray500)),
        ]),
        actions: [
          FBButton(
            label: 'View Group',
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
              context.push('/social/groups/$groupId');
            },
          ),
        ],
      ),
    );
  }
}
