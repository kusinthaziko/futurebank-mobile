import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../catalog/coach_catalog.dart';
import '../data/coach_repository.dart';
import '../domain/coach_bloc.dart' hide CoachRepository;
import '../domain/coach_event.dart';
import 'coach_view.dart';

class CoachPage extends StatefulWidget {
  final GraphQLClient Function() getGraphqlClient;

  const CoachPage({super.key, required this.getGraphqlClient});

  @override
  State<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends State<CoachPage> {
  late final Catalog _catalog;
  late final SurfaceController _surfaceController;
  late final CoachRepository _repository;
  late final CoachBloc _bloc;

  @override
  void initState() {
    super.initState();
    _catalog = buildCoachCatalog();
    _surfaceController = SurfaceController(catalogs: [_catalog]);
    _repository = CoachRepository(
      graphqlClient: widget.getGraphqlClient(),
      catalog: _catalog,
      surfaceController: _surfaceController,
    );
    _bloc = CoachBloc(repository: _repository)..add(CoachStarted());
  }

  @override
  void dispose() {
    _bloc.close();
    _surfaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: CoachView(surfaceHost: _surfaceController),
    );
  }
}
