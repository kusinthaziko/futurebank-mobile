import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/graphql/client.dart';

class InstitutionsQuery {
  static const _query = r'''
    query Institutions {
      institutions {
        id
        name
        domain
        logo_url
        verified
      }
    }
  ''';

  static Future<List<Map<String, dynamic>>> fetch(WidgetRef ref) async {
    final client = ref.read(graphQLClientProvider(null));
    final result = await client.query(
      QueryOptions(document: gql(_query)),
    );
    if (result.hasException) throw result.exception!;
    final List? data = result.data?['institutions'];
    return data?.cast<Map<String, dynamic>>() ?? [];
  }
}
