import 'package:flutter/material.dart';

class FadeInStaggered extends StatefulWidget {
  final List<Widget> children;
  final int staggerDelayMs;
  final Duration itemDuration;
  final Curve curve;
  final bool animate;
  final Axis slideDirection;
  final double slideOffset;

  const FadeInStaggered({
    super.key,
    required this.children,
    this.staggerDelayMs = 80,
    this.itemDuration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
    this.animate = true,
    this.slideDirection = Axis.vertical,
    this.slideOffset = 16,
  });

  @override
  State<FadeInStaggered> createState() => _FadeInStaggeredState();
}

class _FadeInStaggeredState extends State<FadeInStaggered>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    final count = widget.children.length;
    final totalDuration = widget.itemDuration +
        Duration(milliseconds: widget.staggerDelayMs * (count - 1));

    _ctrl = AnimationController(
      vsync: this,
      duration: totalDuration,
    );

    _fades = List.generate(count, (i) {
      final start = (i * widget.staggerDelayMs) / totalDuration.inMilliseconds;
      final end = (i * widget.staggerDelayMs + widget.itemDuration.inMilliseconds) /
          totalDuration.inMilliseconds;
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
              curve: widget.curve),
        ),
      );
    });

    _slides = List.generate(count, (i) {
      final start = (i * widget.staggerDelayMs) / totalDuration.inMilliseconds;
      final end = (i * widget.staggerDelayMs + widget.itemDuration.inMilliseconds) /
          totalDuration.inMilliseconds;
      final offset = widget.slideDirection == Axis.vertical
          ? Offset(0, widget.slideOffset / 100)
          : Offset(widget.slideOffset / 100, 0);
      return Tween(begin: offset, end: Offset.zero).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
              curve: widget.curve),
        ),
      );
    });

    if (widget.animate) {
      _ctrl.forward();
    }
  }

  @override
  void didUpdateWidget(FadeInStaggered oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_ctrl.isAnimating) {
      _ctrl.reset();
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.children.length, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => Opacity(
            opacity: _fades[i].value,
            child: Transform.translate(
              offset: _slides[i].value * MediaQuery.of(context).size.width,
              child: child,
            ),
          ),
          child: widget.children[i],
        );
      }),
    );
  }
}
