import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../widgets/scanner_chip.dart';
import '../widgets/scanner_overlay_painter.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  MobileScannerController? _controller;
  late AnimationController _scanAnim;
  late Animation<double> _scanPosition;
  bool _torchOn = false;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();

    _scanAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _scanPosition = Tween<double>(begin: 0.08, end: 0.88).animate(
      CurvedAnimation(parent: _scanAnim, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _scanAnim.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture, MobileScannerController ctrl) {
    if (_hasScanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null || barcode!.rawValue!.isEmpty) return;

    _hasScanned = true;
    HapticFeedback.heavyImpact();

    _scanAnim.stop();
    Navigator.of(context).pop(barcode.rawValue);
  }

  void _toggleTorch() {
    setState(() => _torchOn = !_torchOn);
    _controller?.toggleTorch();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanSize = size.width * 0.72;
    final scanLeft = (size.width - scanSize) / 2;
    final scanTop = (size.height - scanSize) / 2 - 40;

    return Scaffold(
      backgroundColor: darkBg,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) => _onDetect(capture, _controller!),
            fit: BoxFit.cover,
          ),
          AnimatedBuilder(
            animation: _scanPosition,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: ScannerOverlayPainter(
                  scanRect: Rect.fromLTWH(scanLeft, scanTop, scanSize, scanSize),
                  cornerColor: gold500,
                  scanLineY: scanTop + scanSize * _scanPosition.value,
                  scanLineWidth: scanSize,
                  scanLineLeft: scanLeft,
                ),
              );
            },
          ),
          _buildTopBar(),
          _buildBottomActions(scanTop, scanSize),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: sp16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(PhosphorIconsRegular.x, color: white, size: 24),
              onPressed: () => Navigator.of(context).pop(),
              splashRadius: 22,
            ),
            const Spacer(),
            Text(
              'futureBank',
              style: AppTextStyles.labelMedium.copyWith(
                color: gold300,
                letterSpacing: 1.2,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(double scanTop, double scanSize) {
    final scanBottom = scanTop + scanSize;

    return Positioned(
      top: scanBottom + 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            'Align QR code within the frame',
            style: AppTextStyles.caption.copyWith(color: white.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScannerChip(
                icon: PhosphorIconsRegular.sun,
                label: 'Flash',
                onTap: _toggleTorch,
                active: _torchOn,
              ),
              const SizedBox(width: 20),
              ScannerChip(
                icon: PhosphorIconsRegular.keyboard,
                label: 'Enter Manually',
                onTap: () => Navigator.of(context).pop(''),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
