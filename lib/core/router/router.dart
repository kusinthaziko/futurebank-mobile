import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system/tokens/icons.dart';
import '../providers/auth_provider.dart';
import '../providers/subscription_providers.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/kyc_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/auth/presentation/screens/biometric_setup_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/accounts/presentation/screens/accounts_screen.dart';
import '../../features/transactions/presentation/screens/transaction_history_screen.dart';
import '../../features/loans/presentation/screens/loans_screen.dart';
import '../../features/loans/presentation/screens/loan_history_screen.dart';
import '../../features/loans/presentation/screens/loan_apply_screen.dart';
import '../../features/loans/presentation/screens/loan_detail_screen.dart';
import '../../features/social/presentation/screens/social_screen.dart';
import '../../features/social/presentation/screens/social_detail_screens.dart';
import '../../features/social/presentation/screens/create_group_screen.dart';
import '../../features/social/presentation/screens/leaderboard_screen.dart';
import '../../features/social/presentation/screens/badge_earned_screen.dart';
import '../../features/ai_coach/presentation/screens/coach_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/health_score_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/passport_screen.dart';
import '../../features/profile/presentation/screens/about_screen.dart';
import '../../features/accounts/presentation/screens/deposit_screen.dart';
import '../../features/accounts/presentation/screens/transfer_screen.dart';
import '../../features/accounts/presentation/screens/qr_scanner_screen.dart';
import '../../features/accounts/presentation/screens/account_detail_screen.dart';
import '../../features/accounts/presentation/screens/receipt_screen.dart';
import '../../features/accounts/presentation/screens/create_goal_screen.dart';

Page<void> _buildPageWithTransition(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            ),
        child: child,
      );
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState is Loading) return null;
      final isAuth = authState.isAuthenticated;
      final loc = state.matchedLocation;
      final isPublic =
          loc == '/' || loc.startsWith('/auth') || loc == '/onboarding';
      // Routes that an already-authenticated user must NOT see (pre-login only).
      // Post-login auth steps (kyc, verify-email, biometric-setup) stay reachable.
      final isPreLoginOnly =
          loc == '/auth/login' ||
          loc == '/auth/register' ||
          loc == '/auth/forgot-password' ||
          loc == '/onboarding';
      if (!isAuth && !isPublic) return '/auth/login';
      if (isAuth && isPreLoginOnly) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (_, __) => _buildPageWithTransition(const SplashScreen()),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const OnboardingScreen()),
      ),
      GoRoute(
        path: '/auth/login',
        pageBuilder: (_, __) => _buildPageWithTransition(const LoginScreen()),
      ),
      GoRoute(
        path: '/auth/register',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const RegisterScreen()),
      ),
      GoRoute(
        path: '/auth/kyc',
        pageBuilder: (_, __) => _buildPageWithTransition(const KycScreen()),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: '/auth/verify-email',
        pageBuilder: (_, s) => _buildPageWithTransition(
          VerifyEmailScreen(email: s.uri.queryParameters['email']),
        ),
      ),
      GoRoute(
        path: '/auth/biometric-setup',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const BiometricSetupScreen()),
      ),
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const DashboardScreen()),
          GoRoute(
            path: '/accounts',
            builder: (_, __) => const AccountsScreen(),
          ),
          GoRoute(path: '/social', builder: (_, __) => const SocialScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
      GoRoute(
        path: '/accounts/:id/history',
        pageBuilder: (_, s) => _buildPageWithTransition(
          TransactionHistoryScreen(accountId: s.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/social/groups/:id',
        pageBuilder: (_, s) => _buildPageWithTransition(
          GroupDetailScreen(groupId: s.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/social/challenges/:id',
        pageBuilder: (_, s) => _buildPageWithTransition(
          ChallengeDetailScreen(challengeId: s.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/social/create-group',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const CreateGroupScreen()),
      ),
      GoRoute(
        path: '/leaderboard',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const LeaderboardScreen()),
      ),
      GoRoute(
        path: '/badge-earned',
        pageBuilder: (_, s) => _buildPageWithTransition(
          BadgeEarnedScreen(
            badgeName: s.uri.queryParameters['name'] ?? 'Achievement',
            badgeType: s.uri.queryParameters['type'] ?? 'achievement',
            pointsAdded:
                int.tryParse(s.uri.queryParameters['points'] ?? '') ?? 150,
          ),
        ),
      ),
      GoRoute(
        path: '/health-score',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const HealthScoreScreen()),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const SettingsScreen()),
      ),
      GoRoute(
        path: '/passport',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const PassportScreen()),
      ),
      GoRoute(
        path: '/loans',
        pageBuilder: (_, __) => _buildPageWithTransition(const LoansScreen()),
      ),
      GoRoute(
        path: '/loans/apply',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const LoanApplyScreen()),
      ),
      GoRoute(
        path: '/loans/history',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const LoanHistoryScreen()),
      ),
      GoRoute(
        path: '/loans/:id',
        pageBuilder: (_, s) => _buildPageWithTransition(
          LoanDetailScreen(loanId: s.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/coach',
        pageBuilder: (_, __) => _buildPageWithTransition(const CoachScreen()),
      ),
      GoRoute(
        path: '/about',
        pageBuilder: (_, __) => _buildPageWithTransition(const AboutScreen()),
      ),
      GoRoute(
        path: '/deposit',
        pageBuilder: (_, __) => _buildPageWithTransition(const DepositScreen()),
      ),
      GoRoute(
        path: '/transfer',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const TransferScreen()),
      ),
      GoRoute(
        path: '/accounts/detail/:id',
        pageBuilder: (_, s) => _buildPageWithTransition(
          AccountDetailScreen(accountId: s.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/qr-scanner',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const QrScannerScreen()),
      ),
      GoRoute(
        path: '/receipt/:id',
        pageBuilder: (_, s) => _buildPageWithTransition(
          ReceiptScreen(receiptId: s.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/accounts/create-goal',
        pageBuilder: (_, __) =>
            _buildPageWithTransition(const CreateGoalScreen()),
      ),
    ],
  );
});

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  DateTime? _lastBackPress;

  @override
  Widget build(BuildContext context) {
    ref.listen(notificationSubscriptionProvider, (_, next) {
      next.whenData((n) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${n['title']}: ${n['body']}'),
            duration: const Duration(seconds: 4),
          ),
        );
      });
    });

    final loc = GoRouterState.of(context).matchedLocation;
    final idx = [
      '/home',
      '/accounts',
      '/social',
      '/profile',
    ].indexWhere((r) => loc.startsWith(r)).clamp(0, 3);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastBackPress == null ||
            now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
          _lastBackPress = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Exit app
          // ignore: deprecated_member_use
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: NavigationBar(
                selectedIndex: idx,
                onDestinationSelected: (i) => context.go(
                  ['/home', '/accounts', '/social', '/profile'][i],
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                indicatorColor: Theme.of(context).colorScheme.primaryContainer,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(FbIcons.home),
                    selectedIcon: Icon(FbIcons.homeFill),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(FbIcons.wallet),
                    selectedIcon: Icon(FbIcons.walletFill),
                    label: 'Accounts',
                  ),
                  NavigationDestination(
                    icon: Icon(FbIcons.users),
                    selectedIcon: Icon(FbIcons.usersFill),
                    label: 'Social',
                  ),
                  NavigationDestination(
                    icon: Icon(FbIcons.user),
                    selectedIcon: Icon(FbIcons.userFill),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
