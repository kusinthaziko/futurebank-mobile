import 'dart:io' show HttpClient, X509Certificate;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart' show IOClient;

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

  final httpLink = () {
    final uri = Uri.parse(_apiUrl);

    if (!kReleaseMode || uri.scheme != 'https') {
      return HttpLink(_apiUrl);
    }

    final rawClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => false;

    return HttpLink(_apiUrl, httpClient: IOClient(rawClient));
  }();

  final link = auth.concat(ws).concat(httpLink);

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(store: HiveStore()),
  );
}

final graphQLClientProvider = Provider.family<GraphQLClient, String?>(
  (ref, token) => buildGraphQLClient(token),
);
