import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/graphql/client.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../data/graphql/queries.dart';
import '../../domain/providers.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/biometric_switch.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/revoke_sessions_dialog.dart';
import '../widgets/sign_out_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _showOnLeaderboard = true;
  bool _publicProfile = false;
  bool _notifications = true;
  bool _blurBalance = false;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final did = ref.watch(profileProvider).asData?.value.user.blockchainDid;
    final kycLevel = ref.watch(profileProvider).asData?.value.user.kycLevel ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(sp16),
        children: [
          const SettingsSectionHeader('Security'),
          const SizedBox(height: sp8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showDialog(context: context, builder: (_) => const ChangePasswordDialog()),
          ),
          const BiometricSwitch(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.devices),
            title: const Text('Active Sessions'),
            trailing: TextButton(
              onPressed: () => showDialog(context: context, builder: (_) => const RevokeSessionsDialog()),
              child: const Text('Revoke All'),
            ),
          ),
          const Divider(height: sp32),
          const SettingsSectionHeader('Privacy'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.blur_on),
            title: const Text('Blur balance on home'),
            value: _blurBalance,
            onChanged: (v) => _updateSetting('blur_balance_enabled', v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.leaderboard),
            title: const Text('Show on leaderboard'),
            value: _showOnLeaderboard,
            onChanged: (v) => _updateSetting('show_on_leaderboard', v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.public),
            title: const Text('Public profile'),
            value: _publicProfile,
            onChanged: (v) => _updateSetting('public_profile', v),
          ),
          const Divider(height: sp32),
          const SettingsSectionHeader('Identity'),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.badge_outlined),
            title: const Text('My DID'),
            subtitle: Text(_truncateDid(did ?? ''), style: AppTextStyles.caption),
            trailing: IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () {
                if (did != null) {
                  Clipboard.setData(ClipboardData(text: did));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('DID copied!')));
                }
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('KYC Status'),
            subtitle: Text('Level $kycLevel', style: AppTextStyles.caption),
            trailing: TextButton(
              onPressed: () => context.push('/auth/kyc'),
              child: const Text('Upgrade'),
            ),
          ),
          const Divider(height: sp32),
          const SettingsSectionHeader('App'),
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
            onChanged: (v) => _updateSetting('notifications_enabled', v),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & FAQ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Clipboard.setData(const ClipboardData(text: 'https://kusinthaziko.github.io/futurebank-pages/help'));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help URL copied')));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0+1', style: AppTextStyles.caption),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/about'),
          ),
          if (_saving) const Padding(
            padding: EdgeInsets.symmetric(vertical: sp8),
            child: LinearProgressIndicator(),
          ),
          const SizedBox(height: sp32),
          FBButton(
            label: 'Sign Out',
            variant: FBButtonVariant.destructive,
            onPressed: () => showDialog(context: context, builder: (_) => const SignOutDialog()),
          ),
          const SizedBox(height: sp32),
        ],
      ),
    );
  }

  Future<void> _updateSetting(String field, bool value) async {
    setState(() {
      _saving = true;
      if (field == 'show_on_leaderboard') _showOnLeaderboard = value;
      if (field == 'public_profile') _publicProfile = value;
      if (field == 'notifications_enabled') _notifications = value;
      if (field == 'blur_balance_enabled') _blurBalance = value;
    });
    try {
      final client = ref.read(graphQLClientProvider(ref.read(accessTokenProvider)));
      await client.mutate(MutationOptions(
        document: gql(updateSettingsMutation),
        variables: {field: value},
      ));
    } catch (_) {
      setState(() {
        if (field == 'show_on_leaderboard') _showOnLeaderboard = !value;
        if (field == 'public_profile') _publicProfile = !value;
        if (field == 'notifications_enabled') _notifications = !value;
        if (field == 'blur_balance_enabled') _blurBalance = !value;
      });
    } finally {
      setState(() => _saving = false);
    }
  }

  String _truncateDid(String did) {
    final parts = did.split(':');
    if (parts.length < 4) return did;
    return 'did:fb:${parts[2]}:****${parts.last.substring(parts.last.length.clamp(4, parts.last.length) - 4)}';
  }
}
