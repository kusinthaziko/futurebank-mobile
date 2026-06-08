import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/dimensions.dart';
import '../../../core/design_system/tokens/typography.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../../auth/domain/auth_state.dart';
import 'force_update_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _forceUpdate = false;
  String _storeUrl = 'https://kusinthaziko.github.io/futurebank-pages/';

  @override
  void initState() {
    super.initState();
    _checkVersionThenNavigate();
  }

  Future<void> _checkVersionThenNavigate() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    try {
      final client = ref.read(graphQLClientProvider(null));
      final result = await client.query(QueryOptions(
        document: gql('''
          query { appConfig { minVersion storeUrl } }
        '''),
        fetchPolicy: FetchPolicy.networkOnly,
      ));

      if (result.data != null) {
        final config = result.data!['appConfig'];
        final minVersion = config['minVersion'] as String;
        final storeUrl = config['storeUrl'] as String;
        final info = await PackageInfo.fromPlatform();
        if (_isOlderThan(info.version, minVersion)) {
          if (mounted) setState(() { _forceUpdate = true; _storeUrl = storeUrl; });
          return;
        }
      }
    } catch (_) {
      // Version check failed — don't block the user
    }

    _navigate();
  }

  bool _isOlderThan(String current, String minimum) {
    final c = current.split('.').map(int.parse).toList();
    final m = minimum.split('.').map(int.parse).toList();
    for (int i = 0; i < 3; i++) {
      final cv = i < c.length ? c[i] : 0;
      final mv = i < m.length ? m[i] : 0;
      if (cv < mv) return true;
      if (cv > mv) return false;
    }
    return false;
  }

  Future<void> _navigate() async {
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
    if (_forceUpdate) return ForceUpdateScreen(storeUrl: _storeUrl);

    return Scaffold(
      backgroundColor: primary700,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_balance, size: 64, color: white),
            const SizedBox(height: sp16),
            Text('futureBank',
                style: AppTextStyles.displayLarge.copyWith(color: white)),
            const SizedBox(height: sp8),
            Text('Campus financial super-app',
                style: AppTextStyles.bodyMedium.copyWith(color: primary300)),
          ],
        ),
      ),
    );
  }
}
