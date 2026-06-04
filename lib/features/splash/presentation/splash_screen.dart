import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/dimensions.dart';
import '../../../core/design_system/tokens/typography.dart';
import '../../../core/providers/auth_provider.dart';
import '../../auth/domain/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    final auth = ref.read(authProvider);
    if (auth is Authenticated) {
      context.go('/home');
    } else {
      const storage = FlutterSecureStorage();
      final onboardingSeen = await storage.read(key: 'onboarding_seen');
      if (!mounted) return;
      if (onboardingSeen != 'true') {
        context.go('/onboarding');
      } else {
        context.go('/auth/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary700,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_balance, size: 64, color: white),
            const SizedBox(height: sp16),
            Text('futureBank', style: AppTextStyles.displayLarge.copyWith(color: white)),
            const SizedBox(height: sp8),
            Text('Campus financial super-app',
                style: AppTextStyles.bodyMedium.copyWith(color: primary300)),
          ],
        ),
      ),
    );
  }
}
