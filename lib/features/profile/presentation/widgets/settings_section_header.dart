import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/typography.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  const SettingsSectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: sp4),
    child: Text(title, style: AppTextStyles.labelLarge.copyWith(color: gray500)),
  );
}
