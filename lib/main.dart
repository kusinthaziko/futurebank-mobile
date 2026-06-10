import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'core/design_system/theme/app_theme.dart';
import 'core/router/router.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/security_provider.dart';
import 'core/graphql/client.dart';
import 'features/auth/domain/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  Timer? _refreshTimer;
  // bool _refreshStarted = false;  // kept for future use

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(autoLockProvider.notifier).onAppLifecycleChange(state);
  }

  void _onAuthChange(AuthState? prev, AuthState next) {
    // Start timer exactly once when transitioning TO authenticated
    if (next is Authenticated && prev is! Authenticated) {
      _startTokenRefresh();
    } else if (next is! Authenticated) {
      _refreshTimer?.cancel();
    }
  }

  void _startTokenRefresh() {
    _refreshTimer?.cancel();
    // _refreshStarted = true;

    // Refresh token proactively every 10 minutes (before 15-min expiry)
    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      try {
        await ref.read(authProvider.notifier).refreshToken();
      } catch (_) {
        // Silent fail — token refresh is best-effort
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final authState = ref.watch(authProvider);

    // Listen for auth transitions exactly once
    ref.listen(authProvider, _onAuthChange);

    // Show splash while auth resolves (prevents queries with null token)
    if (authState is Loading) {
      return MaterialApp(
        title: 'futureBank',
        theme: buildAppTheme(),
        darkTheme: buildDarkAppTheme(),
        themeMode: ThemeMode.system,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    final token = switch (authState) {
      Authenticated(:final accessToken) => accessToken,
      _ => null,
    };

    return GraphQLProvider(
      client: ValueNotifier(ref.watch(graphQLClientProvider(token))),
      child: MaterialApp.router(
        title: 'futureBank',
        theme: buildAppTheme(),
        darkTheme: buildDarkAppTheme(),
        themeMode: ThemeMode.system,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
