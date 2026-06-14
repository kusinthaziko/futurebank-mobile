import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/graphql/client.dart';
import '../../../../core/widgets/error_view.dart';
import '../../data/graphql/queries.dart';

class ChangePasswordDialog extends ConsumerWidget {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    return AlertDialog(
      title: const Text('Change Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: oldCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Current password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: newCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: confirmCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm new password',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FBButton(
          label: 'Update',
          onPressed: () async {
            if (newCtrl.text != confirmCtrl.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Passwords do not match')),
              );
              return;
            }
            if (newCtrl.text.length < 8) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password must be at least 8 characters')),
              );
              return;
            }
            try {
              final token = ref.read(accessTokenProvider);
              final client = ref.read(graphQLClientProvider(token));
              final result = await client.mutate(MutationOptions(
                document: gql(changePasswordMutation),
                variables: {
                  'old_password': oldCtrl.text,
                  'new_password': newCtrl.text,
                },
              ));
              if (result.hasException) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ErrorView.messageFor(result.exception!))),
                  );
                }
                return;
              }
              if (context.mounted) Navigator.pop(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ErrorView.messageFor(e))),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
