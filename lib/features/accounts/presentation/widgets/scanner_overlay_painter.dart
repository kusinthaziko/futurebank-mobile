import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/colors.dart';

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanRect;
  final Color cornerColor;
  final double scanLineY;
  final double scanLineWidth;
  final double scanLineLeft;

  ScannerOverlayPainter({
    required this.scanRect,
    required this.cornerColor,
    required this.scanLineY,
    required this.scanLineWidth,
    required this.scanLineLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(Rect.largest)
        ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(16))),
      paint,
    );

    const cl = 28.0;
    const sw = 3.5;
    final cornerPaint = Paint()
      ..color = cornerColor
      ..strokeWidth = sw
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void drawCorner(Offset pt, double dx, double dy) {
      canvas.drawLine(pt, Offset(pt.dx + dx * cl, pt.dy), cornerPaint);
      canvas.drawLine(pt, Offset(pt.dx, pt.dy + dy * cl), cornerPaint);
    }

    drawCorner(scanRect.topLeft, 1.0, 1.0);
    drawCorner(scanRect.topRight, -1.0, 1.0);
    drawCorner(scanRect.bottomLeft, 1.0, -1.0);
    drawCorner(scanRect.bottomRight, -1.0, -1.0);

    final linePaint = Paint()
      ..color = gold500.withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawLine(
      Offset(scanLineLeft + 16, scanLineY),
      Offset(scanLineLeft + scanLineWidth - 16, scanLineY),
      linePaint,
    );

    final glowPaint = Paint()
      ..color = gold500.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawLine(
      Offset(scanLineLeft + 16, scanLineY),
      Offset(scanLineLeft + scanLineWidth - 16, scanLineY),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter old) =>
      old.scanRect != scanRect || old.scanLineY != scanLineY;
}
