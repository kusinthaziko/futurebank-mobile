// Single responsibility: quick action buttons only
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  static const _actions = [
    (Icons.send,         'Send',    '/transfer'),
    (Icons.add,          'Deposit', '/deposit'),
    (Icons.credit_score, 'Loans',   '/loans'),
    (Icons.group,        'Groups',  '/social'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _actions.map((a) => _ActionButton(
        icon: a.$1, label: a.$2, route: a.$3,
      )).toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  const _ActionButton({required this.icon, required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(color: primary100, borderRadius: radius12),
          child: Icon(icon, color: primary500),
        ),
        const SizedBox(height: sp4),
        Text(label, style: AppTextStyles.caption.copyWith(color: gray700)),
      ]),
    );
  }
}
