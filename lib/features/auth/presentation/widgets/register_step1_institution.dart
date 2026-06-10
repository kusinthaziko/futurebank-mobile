import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class RegisterStep1Institution extends StatefulWidget {
  final List<Map<String, dynamic>> institutions;
  final bool loading;
  final Map<String, dynamic>? selected;
  final ValueChanged<Map<String, dynamic>> onSelect;
  final VoidCallback onContinue;

  const RegisterStep1Institution({
    super.key,
    required this.institutions,
    required this.loading,
    required this.selected,
    required this.onSelect,
    required this.onContinue,
  });

  @override
  State<RegisterStep1Institution> createState() =>
      _RegisterStep1InstitutionState();
}

class _RegisterStep1InstitutionState extends State<RegisterStep1Institution> {
  String _search = '';

  List<Map<String, dynamic>> get _filtered => widget.institutions
      .where(
        (i) =>
            (i['name'] as String).toLowerCase().contains(_search.toLowerCase()),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(sp16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search institution...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: radius12),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        Expanded(
          child: widget.loading
              ? const Center(child: CircularProgressIndicator())
              : _filtered.isEmpty
              ? Center(
                  child: Text(
                    'No institutions found',
                    style: AppTextStyles.bodyMedium.copyWith(color: gray500),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: sp16),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) {
                    final inst = _filtered[i];
                    final selected = widget.selected?['id'] == inst['id'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: sp8),
                      child: ListTile(
                        tileColor: selected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: radius12,
                          side: BorderSide(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : gray300,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          child: Text(
                            inst['name'][0],
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        title: Text(
                          inst['name'],
                          style: AppTextStyles.labelLarge.copyWith(
                            color: onSurface,
                          ),
                        ),
                        subtitle: Text(
                          inst['domain'] ?? '',
                          style: AppTextStyles.caption.copyWith(color: gray500),
                        ),
                        trailing: selected
                            ? Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        onTap: () => widget.onSelect(inst),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(sp16),
          child: FBButton(
            label: 'Continue',
            onPressed: widget.selected != null ? widget.onContinue : null,
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () => context.go('/auth/login'),
            child: RichText(
              text: TextSpan(
                text: 'Already have an account? ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: sp8),
      ],
    );
  }
}
