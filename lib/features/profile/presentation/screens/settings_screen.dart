import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/providers/security_provider.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../domain/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _blurBalance = false;
  bool _showOnLeaderboard = true;
  bool _publicProfile = false;
  bool _notifications = true;
  int _autoLockMinutes = 5;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final did = profileAsync.asData?.value.user.blockchainDid;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(sp16),
        children: [
          const _SectionHeader('Security'),
          const SizedBox(height: sp8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const _BiometricSwitch(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.devices),
            title: const Text('Active Sessions'),
            subtitle: const Text('Current device · This phone'),
            trailing: TextButton(
              onPressed: () {},
              child: const Text('Revoke'),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.timer_outlined),
            title: const Text('Auto-lock timeout'),
            trailing: DropdownButton<int>(
              value: _autoLockMinutes,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 1, child: Text('1 min')),
                DropdownMenuItem(value: 5, child: Text('5 min')),
                DropdownMenuItem(value: 15, child: Text('15 min')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _autoLockMinutes = v);
              },
            ),
          ),
          const Divider(height: sp32),
          const _SectionHeader('Privacy'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.blur_on),
            title: const Text('Blur balance on home'),
            value: _blurBalance,
            onChanged: (v) => setState(() => _blurBalance = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.leaderboard),
            title: const Text('Show on leaderboard'),
            value: _showOnLeaderboard,
            onChanged: (v) => setState(() => _showOnLeaderboard = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.public),
            title: const Text('Public profile'),
            value: _publicProfile,
            onChanged: (v) => setState(() => _publicProfile = v),
          ),
          const Divider(height: sp32),
          const _SectionHeader('Identity'),
          if (did != null) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.badge_outlined),
              title: const Text('My DID'),
              subtitle: Text(_truncateDid(did), style: AppTextStyles.caption),
              trailing: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: did));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('DID copied!')));
                },
              ),
            ),
          ],
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('KYC Status'),
            subtitle: Text('Level ${profileAsync.asData?.value.user.kycLevel ?? 0}',
                style: AppTextStyles.caption),
            trailing: TextButton(
              onPressed: () => context.push('/auth/kyc'),
              child: const Text('Upgrade'),
            ),
          ),
          const Divider(height: sp32),
          const _SectionHeader('App'),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.language),
            title: Text('Language'),
            trailing: Text('English', style: AppTextStyles.bodyMedium),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & FAQ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0+1', style: AppTextStyles.caption),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/about'),
          ),
          const SizedBox(height: sp32),
          FBButton(
            label: 'Sign Out',
            variant: FBButtonVariant.destructive,
            onPressed: () => _confirmLogout(context),
          ),
          const SizedBox(height: sp32),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FBButton(
            label: 'Sign Out',
            variant: FBButtonVariant.destructive,
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/auth/login');
            },
          ),
        ],
      ),
    );
  }

  String _truncateDid(String did) {
    final parts = did.split(':');
    if (parts.length < 4) return did;
    return 'did:fb:${parts[2]}:****${parts.last.substring(parts.last.length.clamp(4, parts.last.length) - 4)}';
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: sp4),
    child: Text(title,
        style: AppTextStyles.labelLarge.copyWith(color: gray500)),
  );
}

class _BiometricSwitch extends ConsumerStatefulWidget {
  const _BiometricSwitch();

  @override
  ConsumerState<_BiometricSwitch> createState() => _BiometricSwitchState();
}

class _BiometricSwitchState extends ConsumerState<_BiometricSwitch> {
  bool _enabled = false;
  bool _available = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bio = ref.read(biometricServiceProvider);
    final available = await bio.isAvailable();
    final enabled = available ? await bio.isEnabled() : false;
    if (mounted) setState(() { _enabled = enabled; _available = available; _loaded = true; });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();
    if (!_available) return const SizedBox.shrink();

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: const Icon(Icons.fingerprint),
      title: const Text('Biometric'),
      subtitle: const Text('Use fingerprint / face to sign in'),
      value: _enabled,
      onChanged: (v) async {
        final bio = ref.read(biometricServiceProvider);
        if (v) {
          final ok = await bio.authenticate('Enable biometric sign in');
          if (!ok) return;
        }
        await bio.setEnabled(v);
        if (mounted) setState(() => _enabled = v);
      },
    );
  }
}
