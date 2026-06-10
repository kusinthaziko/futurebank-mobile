import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class InstitutionPickerSheet extends StatefulWidget {
  final List<Map<String, dynamic>> institutions;
  const InstitutionPickerSheet({super.key, required this.institutions});
  @override
  State<InstitutionPickerSheet> createState() => _InstitutionPickerSheetState();
}

class _InstitutionPickerSheetState extends State<InstitutionPickerSheet> {
  final _search = TextEditingController();
  late List<Map<String, dynamic>> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.institutions;
  }

  void _filter(String query) {
    setState(() {
      _filtered = widget.institutions.where((i) {
        final name = (i['name'] as String).toLowerCase();
        final domain = (i['domain'] as String?)?.toLowerCase() ?? '';
        final q = query.toLowerCase();
        return name.contains(q) || domain.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(sp24, sp16, sp24, sp8),
          child: TextField(
            controller: _search,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search institution...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: radius12),
              contentPadding: const EdgeInsets.symmetric(vertical: sp12),
            ),
            onChanged: _filter,
          ),
        ),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(sp16, 0, sp16, sp24),
            itemCount: _filtered.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final inst = _filtered[i];
              final verified = inst['verified'] == true;
              return ListTile(
                leading: inst['logo_url'] != null
                    ? ClipRRect(
                        borderRadius: radius8,
                        child: Image.network(
                          inst['logo_url'],
                          width: 36,
                          height: 36,
                        ),
                      )
                    : Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: primary100,
                          borderRadius: radius8,
                        ),
                        child: const Icon(
                          Icons.school,
                          color: primary500,
                          size: 20,
                        ),
                      ),
                title: Row(
                  children: [
                    Flexible(
                      child: Text(
                        inst['name'],
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    if (verified) ...[
                      const SizedBox(width: sp4),
                      const Icon(Icons.verified, color: success500, size: 16),
                    ],
                  ],
                ),
                subtitle: inst['domain'] != null
                    ? Text(
                        '@${inst['domain']}',
                        style: AppTextStyles.caption.copyWith(color: gray500),
                      )
                    : null,
                onTap: () => Navigator.pop(context, inst),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<Map<String, dynamic>?> showInstitutionPicker(
  BuildContext context,
  List<Map<String, dynamic>> institutions,
) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => InstitutionPickerSheet(institutions: institutions),
  );
}
