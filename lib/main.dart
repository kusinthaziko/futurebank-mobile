import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'core/design_system/theme.dart';
import 'core/router/router.dart';
import 'core/providers/auth_provider.dart';
import 'core/graphql/client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final token = ref.watch(authProvider).accessToken;

    return GraphQLProvider(
      client: ValueNotifier(ref.watch(graphQLClientProvider(token))),
      child: MaterialApp.router(
        title: 'futureBank',
        theme: buildAppTheme(),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
