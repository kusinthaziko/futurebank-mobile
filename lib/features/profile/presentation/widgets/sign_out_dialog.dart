import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/providers/auth_provider.dart';

class SignOutDialog extends ConsumerWidget {
  const SignOutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FBButton(
          label: 'Sign Out',
          variant: FBButtonVariant.destructive,
          onPressed: () async {
            Navigator.pop(context);
            await ref.read(authProvider.notifier).logout();
            if (context.mounted) context.go('/auth/login');
          },
        ),
      ],
    );
  }
}
