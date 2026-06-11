import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/graphql/client.dart';
import '../../data/graphql/queries.dart';

class RevokeSessionsDialog extends ConsumerWidget {
  const RevokeSessionsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Revoke All Sessions'),
      content: const Text(
        'This will sign out all other devices. Continue?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FBButton(
          label: 'Revoke',
          variant: FBButtonVariant.destructive,
          onPressed: () async {
            try {
              final token = ref.read(accessTokenProvider);
              final client = ref.read(graphQLClientProvider(token));
              await client.mutate(MutationOptions(
                document: gql(revokeAllSessionsMutation),
              ));
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            }
            if (context.mounted) Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
