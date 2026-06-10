import 'package:flutter/material.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class RegisterStep2Details extends StatelessWidget {
  final TextEditingController fullName;
  final TextEditingController studentId;
  final TextEditingController phone;
  final DateTime? dateOfBirth;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final bool canContinue;
  final VoidCallback onContinue;

  const RegisterStep2Details({
    super.key,
    required this.fullName,
    required this.studentId,
    required this.phone,
    required this.dateOfBirth,
    required this.onPickDate,
    required this.onClearDate,
    required this.canContinue,
    required this.onContinue,
  });

  String _formatDate(DateTime d) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(sp24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tell us about you', style: AppTextStyles.titleLarge),
          const SizedBox(height: sp8),
          Text('We need this to verify your identity.',
              style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
          const SizedBox(height: sp32),
          FBInput(label: 'Full Name', hint: 'e.g. Timothy Chalira', controller: fullName),
          const SizedBox(height: sp16),
          FBInput(label: 'Student ID', hint: 'e.g. 2021/CS/001', controller: studentId),
          const SizedBox(height: sp16),
          FBInput(label: 'Phone Number', hint: 'e.g. 0888 123 456', controller: phone, keyboardType: TextInputType.phone),
          const SizedBox(height: sp16),
          GestureDetector(
            onTap: onPickDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
              decoration: BoxDecoration(
                border: Border.all(
                    color: dateOfBirth != null
                        ? Theme.of(context).colorScheme.primary
                        : gray300),
                borderRadius: radius12,
              ),
              child: Row(children: [
                Icon(Icons.calendar_today,
                    color: dateOfBirth != null
                        ? Theme.of(context).colorScheme.primary
                        : gray500,
                    size: 20),
                const SizedBox(width: sp12),
                Text(
                  dateOfBirth != null ? _formatDate(dateOfBirth!) : 'Date of Birth',
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: dateOfBirth != null
                          ? Theme.of(context).colorScheme.onSurface
                          : gray500),
                ),
                const Spacer(),
                if (dateOfBirth != null)
                  GestureDetector(
                    onTap: onClearDate,
                    child: const Icon(Icons.close, size: 18, color: gray500),
                  ),
              ]),
            ),
          ),
          const Spacer(),
          FBButton(label: 'Continue', onPressed: canContinue ? onContinue : null),
        ]),
      ),
    );
  }
}
