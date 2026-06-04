import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/subscription_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/kyc_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/accounts/presentation/screens/accounts_screen.dart';
import '../../features/transactions/presentation/screens/transaction_history_screen.dart';
import '../../features/loans/presentation/screens/loans_screen.dart';
import '../../features/loans/presentation/screens/loan_apply_screen.dart';
import '../../features/loans/presentation/screens/loan_detail_screen.dart';
import '../../features/social/presentation/screens/social_screen.dart';
import '../../features/social/presentation/screens/social_detail_screens.dart';
import '../../features/ai_coach/presentation/screens/coach_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/admin/presentation/screens/admin_screen.dart';
import '../../features/accounts/presentation/screens/deposit_screen.dart';
import '../../features/accounts/presentation/screens/transfer_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final isAuth = authState.isAuthenticated;
      final isPublic = state.matchedLocation.startsWith('/auth') ||
          state.matchedLocation == '/onboarding';
      if (!isAuth && !isPublic) return '/auth/login';
      if (isAuth && isPublic) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/auth/login',    builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/auth/kyc',      builder: (_, __) => const KycScreen()),
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
      GoRoute(path: '/loans',       builder: (_, __) => const LoansScreen()),
      GoRoute(path: '/loans/apply', builder: (_, __) => const LoanApplyScreen()),
      GoRoute(path: '/loans/:id',
          builder: (_, s) => LoanDetailScreen(loanId: s.pathParameters['id']!)),
      GoRoute(path: '/coach',  builder: (_, __) => const CoachScreen()),
      GoRoute(path: '/admin',  builder: (_, __) => const AdminScreen()),
      GoRoute(path: '/deposit',  builder: (_, __) => const DepositScreen()),
      GoRoute(path: '/transfer', builder: (_, __) => const TransferScreen()),
    ],
  );
});

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for real-time notifications app-wide
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

    return Scaffold(
      body: child,
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
    );
  }
}
