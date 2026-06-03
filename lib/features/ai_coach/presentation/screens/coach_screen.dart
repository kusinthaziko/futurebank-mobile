import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/graphql/client.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../data/coach_repository.dart';
import '../../domain/coach_bloc.dart';
import '../coach_view.dart';

class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key});
  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  late final CoachRepositoryImpl _repo;
  late final CoachBloc _bloc;

  @override
  void initState() {
    super.initState();
    final token = ref.read(authProvider).accessToken;
    final client = ref.read(graphQLClientProvider(token));
    _repo = CoachRepositoryImpl(graphqlClient: client);
    _bloc = CoachBloc(repository: _repo)..add(CoachStarted());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Coach'),
          actions: [
            BlocBuilder<CoachBloc, CoachState>(builder: (ctx, state) {
              if (state.messages.isEmpty) return const SizedBox();
              return TextButton(
                onPressed: () => ctx.read<CoachBloc>().add(CoachCleared()),
                child: const Text('Clear'),
              );
            }),
          ],
        ),
        body: _repo.isReady
            ? CoachView(surfaceController: _repo.controller)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
