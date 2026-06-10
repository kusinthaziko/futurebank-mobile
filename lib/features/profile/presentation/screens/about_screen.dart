import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Opens Twitter/X app first, falls back to browser
  Future<void> _openTwitter(String handle) async {
    final username = handle.replaceFirst('@', '');
    final appUri = Uri.parse('twitter://user?screen_name=$username');
    final webUri = Uri.parse('https://x.com/$username');
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('About futureBank')),
      body: ListView(
        padding: const EdgeInsets.all(sp24),
        children: [
          // App identity
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primary700, primary500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: radius16,
                    boxShadow: [
                      BoxShadow(
                        color: primary500.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'f',
                      style: TextStyle(
                        fontFamily: 'ClashDisplay',
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: sp12),
                Text('futureBank', style: AppTextStyles.titleLarge),
                const SizedBox(height: sp4),
                Text(
                  'Version 1.0.0',
                  style: AppTextStyles.caption.copyWith(color: gray500),
                ),
                const SizedBox(height: sp4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: sp12,
                    vertical: sp4,
                  ),
                  decoration: BoxDecoration(
                    color: gold100,
                    borderRadius: radiusPill,
                  ),
                  child: Text(
                    'Campus Financial Super-App',
                    style: AppTextStyles.caption.copyWith(
                      color: gold500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: sp32),

          // Mission
          _Section('Our Mission'),
          const SizedBox(height: sp8),
          Text(
            'We believe every African university student deserves access to real '
            'financial tools — not just mobile money. futureBank brings savings, '
            'peer-to-peer transfers, micro-loans, and AI-powered financial coaching '
            'directly to campus.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.75),
            ),
          ),

          const SizedBox(height: sp32),

          // Founders
          _Section('The Team'),
          const SizedBox(height: sp16),
          _FounderCard(
            name: 'Timothy Chalira',
            role: 'Founder & CEO',
            bio:
                'Driving the vision of accessible campus finance across Africa.',
            twitterHandle: 'TimothyChalira',
            onTwitterTap: _openTwitter,
          ),
          const SizedBox(height: sp12),
          _FounderCard(
            name: 'Redson Ngwira',
            role: 'Co-Founder & CTO',
            bio: 'Full-stack engineer building the product end to end.',
            twitterHandle: 'RedsoNNgwira',
            onTwitterTap: _openTwitter,
          ),

          const SizedBox(height: sp32),

          // Legal & support
          _Section('Legal & Support'),
          const SizedBox(height: sp8),
          _LinkTile(
            Icons.privacy_tip_outlined,
            'Privacy Policy',
            () => _openUrl('https://futurebank.app/privacy'),
          ),
          _LinkTile(
            Icons.description_outlined,
            'Terms of Service',
            () => _openUrl('https://futurebank.app/terms'),
          ),
          _LinkTile(
            Icons.help_outline,
            'Help & Support',
            () => _openUrl('mailto:support@futurebank.app'),
          ),
          _LinkTile(
            Icons.bug_report_outlined,
            'Report a Bug',
            () => _openUrl('mailto:bugs@futurebank.app'),
          ),
          const SizedBox(height: sp32),
          Center(
            child: Text(
              'Made with ❤️ in Malawi 🇲🇼\n© 2026 futureBank. All rights reserved.',
              style: AppTextStyles.caption.copyWith(color: gray500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: sp32),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section(this.title);
  @override
  Widget build(BuildContext context) => Text(
    title,
    style: AppTextStyles.titleMedium.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    ),
  );
}

class _FounderCard extends StatelessWidget {
  final String name;
  final String role;
  final String bio;
  final String twitterHandle;
  final Future<void> Function(String) onTwitterTap;

  const _FounderCard({
    required this.name,
    required this.role,
    required this.bio,
    required this.twitterHandle,
    required this.onTwitterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: radius16,
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: primary100,
            child: Text(
              name[0],
              style: AppTextStyles.titleMedium.copyWith(color: primary500),
            ),
          ),
          const SizedBox(width: sp12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.labelLarge),
                Text(
                  role,
                  style: AppTextStyles.caption.copyWith(color: primary500),
                ),
                const SizedBox(height: sp4),
                Text(
                  bio,
                  style: AppTextStyles.caption.copyWith(color: gray500),
                ),
              ],
            ),
          ),
          const SizedBox(width: sp8),
          GestureDetector(
            onTap: () => onTwitterTap(twitterHandle),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: sp10,
                vertical: sp6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1DA1F2).withValues(alpha: 0.1),
                borderRadius: radiusPill,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.alternate_email,
                    size: 13,
                    color: Color(0xFF1DA1F2),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    twitterHandle,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF1DA1F2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _LinkTile(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: primary500, size: 20),
    title: Text(label, style: AppTextStyles.bodyMedium),
    trailing: const Icon(Icons.open_in_new, size: 14, color: gray500),
    onTap: onTap,
  );
}
