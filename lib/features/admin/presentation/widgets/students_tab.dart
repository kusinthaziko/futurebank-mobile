import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../domain/providers.dart';

class StudentsTab extends ConsumerStatefulWidget {
  const StudentsTab({super.key});

  @override
  ConsumerState<StudentsTab> createState() => _StudentsTabState();
}

class _StudentsTabState extends ConsumerState<StudentsTab> {
  final _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(adminStudentsProvider(_search.isEmpty ? null : _search));
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(sp16),
        child: TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            hintText: 'Search by name or student ID',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchCtrl.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _search = '');
                    },
                  )
                : null,
            border: OutlineInputBorder(borderRadius: radius12),
            contentPadding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
          ),
          onChanged: (v) => setState(() => _search = v.trim()),
        ),
      ),
      Expanded(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(
            child: Text('Search failed',
                style: AppTextStyles.bodyMedium.copyWith(color: gray500))),
          data: (students) {
            if (students.isEmpty) {
              return Center(child: Text(
                  _search.isEmpty ? 'No students found' : 'No results for "$_search"',
                  style: AppTextStyles.bodyMedium.copyWith(color: gray500)));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: sp16),
              itemCount: students.length,
              itemBuilder: (_, i) {
                final s = students[i];
                final hs = s['health_score'] as int? ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: sp8),
                  child: FBCard(
                    onTap: () => _showStudentDetail(context, s),
                    child: Row(children: [
                      FBAvatar(name: s['full_name'] as String? ?? ''),
                      const SizedBox(width: sp12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${s['full_name']}',
                              style: AppTextStyles.labelLarge),
                          Row(children: [
                            _InfoChip('KYC ${s['kyc_level']}',
                                (s['kyc_level'] as int? ?? 0) >= 2
                                    ? success500 : warning500),
                            const SizedBox(width: sp8),
                            _InfoChip('$hs', primary500),
                          ]),
                        ],
                      )),
                      Text('MWK ${s['balance'] ?? '0'}',
                          style: AppTextStyles.labelLarge.copyWith(
                              color: primary500)),
                    ]),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]);
  }

  void _showStudentDetail(BuildContext context, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${student['full_name']}'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _DetailRow('KYC Level', '${student['kyc_level']}'),
          _DetailRow('Health Score', '${student['health_score']}'),
          _DetailRow('Balance', 'MWK ${student['balance'] ?? '0'}'),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoChip(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: radius4,
    ),
    child: Text(label,
        style: AppTextStyles.caption.copyWith(color: color, fontSize: 10)),
  );
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: sp4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
      Text(value, style: AppTextStyles.labelLarge),
    ]),
  );
}
