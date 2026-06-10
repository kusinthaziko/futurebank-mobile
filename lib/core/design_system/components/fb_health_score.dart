import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';

class FBHealthScoreMeter extends StatefulWidget {
  final int score;
  final double size;
  const FBHealthScoreMeter({super.key, required this.score, this.size = 120});

  @override
  State<FBHealthScoreMeter> createState() => _FBHealthScoreMeterState();
}

class _FBHealthScoreMeterState extends State<FBHealthScoreMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = Tween<double>(
      begin: 0,
      end: widget.score / 1000,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String get _tier => widget.score >= 900
      ? 'Elite'
      : widget.score >= 700
      ? 'Excellent'
      : widget.score >= 500
      ? 'Good'
      : widget.score >= 300
      ? 'Fair'
      : 'Poor';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => CustomPaint(
          painter: _ArcPainter(_anim.value),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.score}',
                  style: AppTextStyles.displayMedium.copyWith(
                    fontSize: widget.size * 0.2,
                  ),
                ),
                Text(
                  _tier,
                  style: AppTextStyles.labelMedium.copyWith(color: gray500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  _ArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    // Background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = gray100
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc — color interpolated
    final color = Color.lerp(
      error500,
      Color.lerp(warning500, success500, (progress - 0.5).clamp(0, 1) * 2)!,
      progress.clamp(0, 0.5) * 2,
    )!;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      Paint()
        ..color = color
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

class FBTransactionTile extends StatelessWidget {
  final String description;
  final String amount;
  final String type;
  final String status;
  final String timeAgo;

  const FBTransactionTile({
    super.key,
    required this.description,
    required this.amount,
    required this.type,
    this.status = 'completed',
    this.timeAgo = '',
  });

  bool get _isCredit =>
      type == 'deposit' ||
      type == 'interest_credit' ||
      type == 'loan_disbursement';

  @override
  Widget build(BuildContext context) {
    final (statusBg, statusFg) = switch (status) {
      'completed' => (success100, success500),
      'pending' || 'processing' => (warning100, warning500),
      _ => (error100, error500),
    };

    return SizedBox(
      height: 64,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isCredit ? success100 : error100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: _isCredit ? success500 : error500,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  timeAgo,
                  style: AppTextStyles.caption.copyWith(color: gray500),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_isCredit ? '+' : '-'}$amount',
                style: AppTextStyles.labelLarge.copyWith(
                  color: _isCredit ? success500 : error500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: statusFg,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
