import 'dart:math';
import 'package:flutter/material.dart';
import '../../design_system/tokens/icons.dart';

class SuccessCelebration extends StatefulWidget {
  final String? message;
  final VoidCallback? onComplete;

  const SuccessCelebration({super.key, this.message, this.onComplete});

  static Future<void> show(
    BuildContext context, {
    String? message,
    VoidCallback? onComplete,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => SuccessCelebration(
        message: message,
        onComplete: onComplete,
      ),
    );
  }

  @override
  State<SuccessCelebration> createState() => _SuccessCelebrationState();
}

class _SuccessCelebrationState extends State<SuccessCelebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _checkScale;
  late final Animation<double> _checkOpacity;
  late final Animation<double> _confettiProgress;

  static const _confettiColors = [
    Color(0xFFFF8F00),
    Color(0xFF00695C),
    Color(0xFF7C4DFF),
    Color(0xFF0D9B64),
    Color(0xFFDC2626),
    Color(0xFF1A56DB),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _checkScale = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _checkOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _confettiProgress = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Material(
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...List.generate(30, (i) => _ConfettiParticle(
                index: i,
                progress: _confettiProgress.value,
                color: _confettiColors[i % _confettiColors.length],
              )),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: _checkOpacity.value,
                    child: Transform.scale(
                      scale: _checkScale.value,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.4),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(FbIcons.check,
                            color: Colors.white, size: 44),
                      ),
                    ),
                  ),
                  if (widget.message != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      widget.message!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfettiParticle extends StatelessWidget {
  final int index;
  final double progress;
  final Color color;

  const _ConfettiParticle({
    required this.index,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final rng = Random(index * 7);
    final startX = size.width * 0.5 + rng.nextDouble() * 40 - 20;
    final endX = rng.nextDouble() * size.width;
    final endY = rng.nextDouble() * size.height;
    final x = startX + (endX - startX) * progress;
    final y = size.height * 0.4 + (endY - size.height * 0.4) * progress;
    final opacity = progress < 0.3 ? progress / 0.3 : (1 - progress) / 0.7;
    final rotation = progress * 6.28 * (rng.nextDouble() * 3 + 1);

    return Positioned(
      left: x,
      top: y,
      child: Transform.rotate(
        angle: rotation,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(rng.nextBool() ? 0 : 3),
            ),
          ),
        ),
      ),
    );
  }
}
