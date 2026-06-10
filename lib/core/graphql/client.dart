import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _apiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://futurebank-api.onrender.com/api/graphql',
);
const _wsUrl = String.fromEnvironment(
  'WS_URL',
  defaultValue: 'wss://futurebank-api.onrender.com:443/socket/websocket',
);
n/// Ensures the WebSocket URI always has an explicit port to avoid parsing issues.
String _ensureWsUrl(String url) {
  final uri = Uri.parse(url);
  if (uri.port == 0) {
    final defaultPort = uri.scheme == 'wss' || uri.scheme == 'https' ? 443 : 80;
    return uri.replace(port: defaultPort).toString();
  }
  return url;
}


GraphQLClient buildGraphQLClient(String? token) {
  final authLink = AuthLink(
    getToken: () => token != null ? 'Bearer $token' : null,
  );

  final httpLink = HttpLink(_apiUrl);

  final wsLink = WebSocketLink(
    _ensureWsUrl(_wsUrl),
    config: SocketClientConfig(
      initialPayload: token != null ? {'token': token} : null,
      autoReconnect: true,
    ),
  );

  // Queries/mutations → HTTP, subscriptions → WebSocket
  final splitLink = Link.split(
    (request) => request.isSubscription,
    wsLink,
    authLink.concat(httpLink),
  );

  return GraphQLClient(
    link: splitLink,
    cache: GraphQLCache(store: HiveStore()),
  );
}

final graphQLClientProvider = Provider.family<GraphQLClient, String?>(
  (ref, token) => buildGraphQLClient(token),
);
