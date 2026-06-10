import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/icons.dart';
import '../../../../core/design_system/tokens/typography.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  static const _actions = [
    (FbIcons.arrowUpRight, 'Send',    '/transfer',  [primary500, primary400]),
    (FbIcons.arrowDown, 'Deposit', '/deposit',   [Color(0xFF0D9B64), Color(0xFF34C78A)]),
    (FbIcons.creditCard,'Loans',  '/loans',     [Color(0xFFD4A017), Color(0xFFE8C547)]),
    (FbIcons.users,      'Social',  '/social',    [Color(0xFF7C3AED), Color(0xFFA78BFA)]),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _actions
          .map((a) => _ActionButton(
                icon: a.$1,
                label: a.$2,
                route: a.$3,
                colors: a.$4.cast<Color>(),
              ))
          .toList(),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String route;
  final List<Color> colors;
  const _ActionButton(
      {required this.icon,
      required this.label,
      required this.route,
      required this.colors});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    lowerBound: 0.9,
    upperBound: 1.0,
    value: 1.0,
  );

  void _onTapDown(_) => _ctrl.reverse();
  void _onTapUp(_) {
    _ctrl.forward();
    HapticFeedback.lightImpact();
    context.push(widget.route);
  }
  void _onTapCancel() => _ctrl.forward();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _ctrl,
        child: Column(children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: radius16,
              boxShadow: [
                BoxShadow(
                  color: widget.colors.first.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(widget.icon, color: white, size: 22),
          ),
          const SizedBox(height: sp6),
          Text(widget.label,
              style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}
