import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/security_provider.dart';

class BiometricSwitch extends ConsumerStatefulWidget {
  const BiometricSwitch({super.key});
  @override
  ConsumerState<BiometricSwitch> createState() => _BiometricSwitchState();
}

class _BiometricSwitchState extends ConsumerState<BiometricSwitch> {
  bool _enabled = false;
  bool _available = false;
  bool _loaded = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final bio = ref.read(biometricServiceProvider);
    final available = await bio.isAvailable();
    final enabled = available ? await bio.isEnabled() : false;
    if (mounted) setState(() { _enabled = enabled; _available = available; _loaded = true; });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || !_available) return const SizedBox.shrink();
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: const Icon(Icons.fingerprint),
      title: const Text('Biometric'),
      subtitle: const Text('Use fingerprint / face to sign in'),
      value: _enabled,
      onChanged: (v) async {
        final bio = ref.read(biometricServiceProvider);
        if (v) { final ok = await bio.authenticate('Enable biometric sign in'); if (!ok) return; }
        await bio.setEnabled(v);
        if (mounted) setState(() => _enabled = v);
      },
    );
  }
}
