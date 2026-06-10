import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system/tokens/colors.dart';
import '../design_system/tokens/dimensions.dart';
import '../design_system/tokens/icons.dart';
import '../design_system/tokens/typography.dart';

final connectivityProvider = StreamProvider<bool>((ref) =>
    Connectivity().onConnectivityChanged
        .map((results) => results.any((r) => r != ConnectivityResult.none)));

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(connectivityProvider).value ?? true;
    if (online) return const SizedBox.shrink();
    return Container(
      color: warning500,
      padding: const EdgeInsets.symmetric(vertical: sp4),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(FbIcons.wifiOff, color: Colors.white, size: 14),
        const SizedBox(width: sp4),
        Text('Offline — showing cached data',
            style: AppTextStyles.caption.copyWith(color: Colors.white)),
      ]),
    );
  }
}
