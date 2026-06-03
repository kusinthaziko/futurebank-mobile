import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _apiUrl = String.fromEnvironment('API_URL',
    defaultValue: 'http://localhost:4000/api/graphql');
const _wsUrl = String.fromEnvironment('WS_URL',
    defaultValue: 'ws://localhost:4000/socket/websocket');

GraphQLClient buildGraphQLClient(String? token) {
  final auth = AuthLink(getToken: () => token != null ? 'Bearer $token' : null);

  final ws = WebSocketLink(
    _wsUrl,
    config: SocketClientConfig(
      initialPayload: token != null ? {'token': token} : null,
    ),
  );

  final http = HttpLink(_apiUrl);
  final link = auth.concat(ws).concat(http);

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(store: HiveStore()),
  );
}

final graphQLClientProvider = Provider.family<GraphQLClient, String?>(
  (ref, token) => buildGraphQLClient(token),
);
