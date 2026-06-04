import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/graphql/client.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../auth/domain/auth_state.dart';
import '../coach_page.dart';

class CoachScreen extends ConsumerWidget {
  const CoachScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final token = auth is Authenticated ? auth.accessToken : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Coach'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
      body: CoachPage(
        getGraphqlClient: () => ref.read(graphQLClientProvider(token)),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('Clear conversation'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
