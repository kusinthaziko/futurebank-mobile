import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../features/admin/presentation/screens/admin_screen.dart';
import '../../features/accounts/presentation/screens/deposit_screen.dart';
import '../../features/accounts/presentation/screens/transfer_screen.dart';
import '../../features/accounts/presentation/screens/account_detail_screen.dart';
import '../../features/accounts/presentation/screens/receipt_screen.dart';
import '../../features/accounts/presentation/screens/create_goal_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState is Loading) return null;
      final isAuth = authState.isAuthenticated;
      final loc = state.matchedLocation;
      final isPublic = loc == '/' ||
          loc.startsWith('/auth') ||
          loc == '/onboarding';
      if (!isAuth && !isPublic) return '/auth/login';
      if (isAuth && (isPublic && loc != '/')) return '/home';
      if (isAuth && loc.startsWith('/admin')) {
        final role = authState is Authenticated ? authState.role : null;
        if (role == null || !['finance_manager', 'auditor', 'admin', 'super_admin'].contains(role)) {
          return '/home';
        }
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/auth/login',      builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/auth/register',   builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/auth/kyc',        builder: (_, __) => const KycScreen()),
      GoRoute(path: '/auth/forgot-password',
          builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/auth/verify-email',
          builder: (_, s) => VerifyEmailScreen(
            email: s.uri.queryParameters['email'],
          )),
      GoRoute(path: '/auth/biometric-setup',
          builder: (_, __) => const BiometricSetupScreen()),
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/home',     builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/accounts', builder: (_, __) => const AccountsScreen()),
          GoRoute(path: '/social',   builder: (_, __) => const SocialScreen()),
          GoRoute(path: '/profile',  builder: (_, __) => const ProfileScreen()),
        ],
      ),
      GoRoute(path: '/accounts/:id/history',
          builder: (_, s) => TransactionHistoryScreen(accountId: s.pathParameters['id']!)),
      GoRoute(path: '/social/groups/:id',
          builder: (_, s) => GroupDetailScreen(groupId: s.pathParameters['id']!)),
      GoRoute(path: '/social/challenges/:id',
          builder: (_, s) => ChallengeDetailScreen(challengeId: s.pathParameters['id']!)),
      GoRoute(path: '/social/create-group',
          builder: (_, __) => const CreateGroupScreen()),
      GoRoute(path: '/leaderboard',
          builder: (_, __) => const LeaderboardScreen()),
      GoRoute(path: '/badge-earned',
          builder: (_, s) => BadgeEarnedScreen(
            badgeName: s.uri.queryParameters['name'] ?? 'Achievement',
            badgeType: s.uri.queryParameters['type'] ?? 'achievement',
            pointsAdded: int.tryParse(s.uri.queryParameters['points'] ?? '') ?? 150,
          )),
      GoRoute(path: '/health-score',
          builder: (_, __) => const HealthScoreScreen()),
      GoRoute(path: '/settings',
          builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/passport',
          builder: (_, __) => const PassportScreen()),
      GoRoute(path: '/loans',       builder: (_, __) => const LoansScreen()),
      GoRoute(path: '/loans/apply', builder: (_, __) => const LoanApplyScreen()),
      GoRoute(path: '/loans/history', builder: (_, __) => const LoanHistoryScreen()),
      GoRoute(path: '/loans/:id',
          builder: (_, s) => LoanDetailScreen(loanId: s.pathParameters['id']!)),
      GoRoute(path: '/coach',  builder: (_, __) => const CoachScreen()),
      GoRoute(path: '/about',  builder: (_, __) => const AboutScreen()),
      GoRoute(path: '/admin',  builder: (_, __) => const AdminScreen()),
      GoRoute(path: '/deposit',  builder: (_, __) => const DepositScreen()),
      GoRoute(path: '/transfer', builder: (_, __) => const TransferScreen()),
      GoRoute(
        path: '/accounts/detail/:id',
        builder: (_, s) => AccountDetailScreen(accountId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/receipt/:id',
        builder: (_, s) => ReceiptScreen(receiptId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/accounts/create-goal',
        builder: (_, __) => const CreateGoalScreen(),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${n['title']}: ${n['body']}'),
          duration: const Duration(seconds: 4),
        ));
      });
    });

    final loc = GoRouterState.of(context).matchedLocation;
    final idx = ['/home', '/accounts', '/social', '/profile']
        .indexWhere((r) => loc.startsWith(r))
        .clamp(0, 3);

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
        bottomNavigationBar: NavigationBar(
          selectedIndex: idx,
          onDestinationSelected: (i) => context.go(
              ['/home', '/accounts', '/social', '/profile'][i]),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet), label: 'Accounts'),
            NavigationDestination(icon: Icon(Icons.group_outlined),
                selectedIcon: Icon(Icons.group), label: 'Social'),
            NavigationDestination(icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
